/* EDIT/CONCLUSIONS: after a day I think this raises a bug where I'm stuck at login screen (either "unlock" button, or just everything greyed out, which forced me to reboot a few times blehhh) */

{
  config,
  pkgs,
  ...
}:

{

  /*
    Enable fingerprint scanner, for more info see: https://wiki.nixos.org/wiki/Fingerprint_scanner
      - To add a fingerprint (KDE), go to "Settings" >  "Manage user accounts" (idk how to do via cli)
      - ==> EDIT/CONCLUSIONS: after a day I think this raises a bug where I'm stuck at login screen (either "unlock" button, or just everything greyed out, which forced me to reboot a few times blehhh)
  */
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090; # driver for 2016 ThinkPads

}
