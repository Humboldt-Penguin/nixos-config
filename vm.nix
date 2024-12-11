{ config, pkgs, ... }:

{
  ## source: https://www.youtube.com/watch?v=rCVW8BGnYIc

  # Enable dconf (System Management Tool)
  programs.dconf.enable = true;

  # Add user to libvirtd group
  users.users.lain.extraGroups = [ "libvirtd" ];

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-manager-qt
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    spice-vdagent    # for copy-pasting...?
    # win-virtio -- this doesn't even exist???? i guess it's an alias for `virtio-win`, since `just get-path ...` gives same results for both versions
    virtio-win
    win-spice
    gnome.adwaita-icon-theme
  ];

  # Manage the virtualisation services
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

}
