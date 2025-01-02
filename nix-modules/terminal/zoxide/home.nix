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

      enable = true;
      package = pkgs.zoxide;

      options = [
        "--cmd cd"
      ];

    };
  };

}
