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
    kitty = {

      enable = true;
      package = pkgs.kitty;

      themeFile = "gruvbox-dark-hard";

      settings = {
        cursor_shape = "beam";
        font_size = 9;
      };

    };
  };

}
