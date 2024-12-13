# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./temp_cs336_configuration.nix
      ./temp_cs352_configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-ecdb2bd2-7a19-42dc-bfea-76560be3fa4a".device = "/dev/disk/by-uuid/ecdb2bd2-7a19-42dc-bfea-76560be3fa4a";
  networking.hostName = "wired"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # # TODO: Once I learn how to store secrets, try to declaratively connect to ruwireless secure (lol) -- this snippet is taken from RUSLUG discord
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


  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
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

  # # Enable the X11 windowing system.
  # # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;
  ## ^ disabling this raises "SDDM requires either services.xserver.enable or services.displayManager.sddm.wayland.enable to be true", so i add:
  services.displayManager.sddm.wayland.enable = true;   # TODO: consolidate all "services" stuff :3

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
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


  ## Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs = {
    chromium = {
      enable = true;
      defaultSearchProviderEnabled = true;
      defaultSearchProviderSearchURL = "https://duckduckgo.com/?t=h_&q={searchTerms}";
    };
  };


  # ## Enable fingerprint scanner, for more info see: https://wiki.nixos.org/wiki/Fingerprint_scanner
  # systemd.services.fprintd = {
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig.Type = "simple";
  # };
  # services.fprintd.enable = true;
  # services.fprintd.tod.enable = true;
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090; # driver for 2016 ThinkPads
  # ## To add a fingerprint (KDE), go to "Settings" >  "Manage user accounts" (idk how to do via cli)
  # ## ==> Edit/conclusion: after a day I think this raises a bug where I'm stuck at login screen (either "unlock" button, or just everything greyed out, which forced me to reboot a few times blehhh)



  ## Enable zsh (following these instructions: https://nixos.wiki/wiki/Command_Shell)
  programs.zsh.enable = true;          # > "When adding a new shell, always enable the shell system-wide, even if it's already enabled in your Home Manager configuration, otherwise it won't source the necessary files."
  # users.defaultUserShell = pkgs.zsh;   # Enable globally
  users.users.lain.shell = pkgs.zsh;   # Enable for my own user


  /*
    Enable + configure keyd.
      - [RESOURCES:]
        - NixOS wiki (helpful but not comprehensive): https://wiki.nixos.org/wiki/Keyd
      - [REFERENCE:]
        - Check status (if it's running/failed, uptime, errors with conf file, etc.) with: `sudo systemctl status keyd` (or `restart` instead of `status).
      - [SELF NOTES:]
        - There's some extra companion config in `home.nix` to write a home file to allow unicode symbols like em dash. When I modularize everything, I'll make that more spatially associated with this stuff.
  */
  services.keyd = {
    enable = true;
    ## The following writes to a conf file in "/etc/keyd/".
    keyboards = {
      keybinds = {    # this is just the name of the config file, doesn't really matter
        ids = [ "*" ];    # apply to all keyboards
        settings = {
          alt = {
            i = "up";
            j = "left";
            k = "down";
            l = "right";

            u = "home";
            o = "end";

            y = "pageup";
            p = "pagedown";

            "-" = "—";
            # "=" = "⟹";    # todo (mid priority): this gives error "ERROR: line 8: invalid key or action"

            n = "macro(A-left)";
            m = "macro(A-down)";
            "," = "macro(A-up)";
            "." = "macro(A-right)";
          };
        };
      };
    };
  };
  ## "Optional, but makes sure that when you type the make palm rejection work with keyd" (see nixos wiki for more info and github:keyd issue)
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';


}
