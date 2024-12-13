{ config, pkgs, ... }:

{
  /* Options for "vswitch": https://search.nixos.org/packages?query=vswitch */
  virtualisation.vswitch = {
    enable  = true;
    package = pkgs.openvswitch;
  };
}
