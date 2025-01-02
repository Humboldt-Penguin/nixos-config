{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  pkgs-stable-unfree,
  pkgs-unstable-unfree,
  ...
}:

{

  programs = {
    zoxide = {

      /*
        - Taken from docs verbatim: https://wiki.nixos.org/wiki/Zoxide
        - Installs `fzf` as well, so `cdi` works.
      */

      enable = true;
      package = pkgs.zoxide;

      options = [
        "--cmd cd"
      ];

    };
  };

}
