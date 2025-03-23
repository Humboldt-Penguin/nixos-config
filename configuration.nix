{ config, pkgs, ... }:

{
  imports = [
    ./nix-modules/.hardware-configuration/ThinkPad_X1_Yoga_4th.nix

    ./nix-modules/apps/chromium/system.nix
    ./nix-modules/apps/steam/system.nix

    # ./nix-modules/system/fprintd/system.nix  /* see explanation at top of module file for why this is bad/buggy */
    ./nix-modules/system/kde/system.nix
    ./nix-modules/system/keyd/system.nix

    ./nix-modules/terminal/podman/system.nix
    ./nix-modules/terminal/zsh/system.nix
  ];



  /* Bootloader. */
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-ecdb2bd2-7a19-42dc-bfea-76560be3fa4a".device = "/dev/disk/by-uuid/ecdb2bd2-7a19-42dc-bfea-76560be3fa4a";
  networking.hostName = "wired"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  /* Configure network proxy if necessary */
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  /* Enable networking */
  networking.networkmanager.enable = true;

  /* TODO: Once I learn how to store secrets, try to declaratively connect to ruwireless secure (lol) -- this snippet is taken from RUSLUG discord */
  # networking.wireless.enable = true;
  # networking.wireless.userControlled.enable = true;
  # networking.wireless.networks."RUWireless Secure" = {
  #   hidden = true;
  #   authProtocols = [ "WPA-EAP" ];
  #   auth = ''
  #     ca_cert="/etc/cert/usertrustrsacertificationauthority.cer"
  #     eap=TTLS
  #     identity="${netid}"
  #     password="${password}"
  #     phase2="auth=PAP"
  #   '';
  # };


  /* Enable bluetooth */
  hardware.bluetooth.enable = true;

  /* Set your time zone. */
  time.timeZone = "America/New_York";

  /* Select internationalisation properties. */
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };


  /* Configure keymap in X11 */
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    /* Default value is `"terminate:ctrl_alt_bksp"` which CLOSES ALL MY FUCKING WINDOWS (terminates X server). This has happened four times to great dismay before I figured out the culprit. Woohoo. */
    options = "";
  };

  /* Enable CUPS to print documents. */
  services.printing.enable = true;

  /* Enable sound with pipewire. */
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  /* Enable touchpad support (enabled default in most desktopManager). */
  # services.xserver.libinput.enable = true;

  /* Define a user account. Don't forget to set a password with ‘passwd’. */
  users.users.lain = {
    isNormalUser = true;
    description = "Lain Iwakura";
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [
    #   # kdePackages.kate
    #   # thunderbird
    # ];
  };

  # # List packages installed in system profile. To search, run:
  # # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   # wget
  # ];

  /* Allow unfree packages */
  nixpkgs.config.allowUnfree = true;


  /* Some programs need SUID wrappers, can be configured further or are */
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  /* List services that you want to enable: */

  /* Enable the OpenSSH daemon. */
  # services.openssh.enable = true;

  /* Open ports in the firewall. */
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?


  /* Enable flakes */
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  /* Automatically optimize the store during every build (https://wiki.nixos.org/wiki/Storage_optimization ) */
  nix.settings.auto-optimise-store = true;

}
