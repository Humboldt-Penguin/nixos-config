{
  config,
  pkgs,
  ...
}:

{

  /* Open TCP/UDP ports 53317 for localsend — this can also be achieved with `programs.localsend.openFirewall`, but I think that forces a system-level install which I don't want, I want it to be home-manager only. */

  # networking.firewall.allowedTCPPorts = [ 53317 ];
  # networking.firewall.allowedUDPPorts = [ 53317 ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
  };

}
