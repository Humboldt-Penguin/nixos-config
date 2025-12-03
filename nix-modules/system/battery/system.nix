{
  config,
  pkgs,
  ...
}:

{

  /* PREFACE: some info/quotes taken from https://wiki.nixos.org/wiki/Laptop */


  /* -------------------------- [1. CORE TLP TWEAKS] -------------------------- */

  /* "To enable the stock NixOS power management tool which allows for managing hibernate and suspend states you can write [below]. This tool is compatible with the other tools mentioned, but the other tools may overwrite this setting." */
  powerManagement.enable = true;

  /* PPD ("power profile daemon", KDE default) conflicts with TLP (linux advanced power management for laptops, esp thinkpad); turn off PPD so TLP can manage power/battery. */
  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {

      /*
        Start/stop charging thresholds for main battery.
          - Note: On my ThinkPad (X1 Yoga4), the main battery is "battery 0"/"BAT0" -- for a list, see `ls /sys/class/power_supply/` (feel free to explore these directories for cool stuff!!)
          - Note: Configuring these values via the KDE settings is buggy, they often both reset to 100% after rebooting. Hardcoding like this keeps it permanent.
      */
      START_CHARGE_THRESH_BAT0 = 60;  # "Start charging once below..."
      STOP_CHARGE_THRESH_BAT0  = 80;  # "Stop charging at..."

      /* CPU policies: smoother on battery, fast on AC */
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;  # allow short bursts for responsiveness

      /* (see options with: `cat /sys/firmware/acpi/platform_profile_choices`) */
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "balanced";

      /* Runtime PM / ASPM */
      RUNTIME_PM_ON_AC = "on";  # keep devices fully awake on AC
      RUNTIME_PM_ON_BAT = "auto";
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "default";

      /* Storage (SATA/NVMe) power */
      NVME_APST_ON_AC = 1;
      NVME_APST_ON_BAT = 1;

      /* Networking niceties */
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "off";  # TODO: If you want to squeeze a bit extra battery life, set this to "on"
      WOL_DISABLE = "Y";

      /* Audio -- if you hear weird audio pops, tweak this between 0-10. */
      SOUND_POWER_SAVE_ON_AC = 1;
      SOUND_POWER_SAVE_ON_BAT = 1;
      SOUND_POWER_SAVE_CONTROLLER = "Y";

    };
  };



/* -------------------------- [2. SLEEP/HIBERNATE] -------------------------- */

/*
  - When lid is closed...
    - If plugged in,
      => Suspend
    - Else (unplugged),
      => Suspend for 15 minutes, then hibernate

  - NOTE: For this to work, you MUST also go into KDE settings and configure:
    - Navigate to "System" > "Power Management" > "When sleeping, enter:", and select "Standby, then hibernate (Switch to hibernation after a period of inactivity)" for all three options (ac power, battery, low battery).
    - Explanation:
      - PowerDevil (the KDE power‑management daemon) blocks lid‑switch handling, which means it intercepts lid‑close events and calls its own suspend routine (`systemd-suspend`, I think?) rather than letting `logind` invoke `suspend‑then‑hibernate` (you can verify this by running `systemd-inhibit --list`). To make KDE initiate `suspend‑then‑hibernate`, you have to go into its settings and choose the "Standby, then hibernate" option.
      - TODO: I've found that KDE power settings occasionally reset themselves, which could lead to my laptop fully dying on accident. If you want to fully disable PowerDevil, look into: https://chatgpt.com/s/t_68c77eaaf2188191a40c5a639f8b5f69 .
*/
  services.logind.settings.Login = {
    HandleLidSwitch              = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend";

    /* Unnecessary (default is already "yes") but keeping to remind you that more config is available: https://www.man7.org/linux/man-pages/man5/logind.conf.5.html */
    # extraConfig = ''
    #   LidSwitchIgnoreInhibited=yes
    # ''
  };

  /* More docs here: https://www.freedesktop.org/software/systemd/man/latest/systemd-sleep.conf.html */
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=15min

    HibernateOnACPower=no
    # ^ "If this option is disabled, the countdown of `HibernateDelaySec=` starts only **after AC power is disconnected**, keeping the system in the suspend state otherwise." (available since systemd 257, verify your own with `systemctl --version`)
    # ^ This *might* be redundant with `services.logind.settings.Login.HandleLidSwitchExternalPower = "suspend"` above, but no harm in being explicit.
  '';


  /* Prevent mouse USB receiver from waking the laptop while it's suspended (e.g. 15 min window before hibernate). */
  services.udev.extraRules = ''
    ACTION=="add|change", \
      SUBSYSTEM=="usb", \
      ATTRS{idVendor}=="046d", \
      TEST=="power/wakeup", \
      ATTR{power/wakeup}="disabled"
  '';


  /* Force hibernate when battery is critically low. */
  services.upower = {
    enable = true;
    criticalPowerAction = "Hibernate";
    usePercentageForPolicy = true;
    percentageLow = 15;
    percentageCritical = 7;
    percentageAction = 5;
  };


  /*
    NOTE: Explicitly setting the swap partition for resume via `boot.resumeDevice` isn't strictly necessary (my laptop resumes from hibernate just fine), but doesn't hurt to include...

    Directly from ChatGPT:

      > On modern NixOS, the initrd uses systemd-hibernate-resume. If you have a single, plain swap partition (like yours), systemd can auto-discover it from your configured swap and scan it for a hibernation image. In that case the explicit `resume=` kernel arg (which `boot.resumeDevice` would add) isn't strictly required.
      > [...]
      > When `boot.resumeDevice` is needed/recommended:
      >
      > - If you switch to a swap file (needs resume_offset) or put swap inside LUKS/LVM.
      > - If you add multiple swap devices and want deterministic behavior.
      > - If auto-detection is flaky on some hardware/firmware combos.
      >
      > It's harmless to set now (future-proofing), but optional for your current single unencrypted swap partition.

    The hardware config doesn't explicitly say the size of the swap partition, but it's 16.8GB appropriately (confirm with `lsblk -no SIZE /dev/disk/by-uuid/3eedb79f-5824-4392-a88c-273bd4b58286`).
  */
  boot.resumeDevice = "/dev/disk/by-uuid/3eedb79f-5824-4392-a88c-273bd4b58286";



  /* -------------------------------- [3. MISC] ------------------------------- */

  /* "Thermald proactively prevents overheating on Intel CPUs and works well with other tools." */
  services.thermald.enable = true;
  /* "Update the CPU microcode for Intel processors." (recommended for security) */
  hardware.cpu.intel.updateMicrocode = true;


  /*
    - archwiki: "fwupd is a simple daemon to allow session software to update device firmware [e.g. BIOS/UEFI, embedded controller, Thunderbolt NVM, some SSDs, docks, Logitech receivers, etc.] on your local machine."
    - For usage instructions, see: https://wiki.archlinux.org/title/Fwupd#Usage
    - TODO: not sure if I can manage device firmware declaratively...? doubt it
  */
  services.fwupd.enable = true;

}
