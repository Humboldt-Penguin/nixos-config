{
  config,
  pkgs,
  ...
}:

{

  /* Enable the X11 windowing system. You can disable this if you're only using the Wayland session. */
  # services.xserver.enable = true;
  ## NOTE: ^ disabling this raises "SDDM requires either services.xserver.enable or services.displayManager.sddm.wayland.enable to be true", so i add:
  services.displayManager.sddm.wayland.enable = true;

  /* Enable the KDE Plasma Desktop Environment. */
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;


  /* Exclude some default applications. */
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    kate  ## this includes kwrite
    elisa
  ];

}
