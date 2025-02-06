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

      /*
      This option takes the file name of a theme in kitty-themes, without the .conf suffix.
        - See <https://github.com/kovidgoyal/kitty-themes/tree/master/themes> for a list of themes.
      */
      # themeFile = "gruvbox-dark-hard";
      themeFile = "Catppuccin-Mocha";

      settings = {
        cursor_shape = "beam";
        font_size = 9;
      };

    };
  };

}
