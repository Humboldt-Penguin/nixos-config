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
    micro = {

      enable = true;
      package = pkgs.micro;

      settings = {
        hltaberrors = true;
        keepautoindent = true;
        tabstospaces = true;

        /*
          - list of themes: https://github.com/zyedidia/micro/tree/master/runtime/colorschemes (no catppuccin uweh!!)
          - alternatively, ctrl+e then `help colors` for a longer explanation / documentation
        */
        # colorscheme = "gruvbox";
        # colorscheme = "twilight";
        colorscheme = "cmc-tc";  # requires `MICRO_TRUECOLOR=1`
      };

    };
  };


  home.file = {
    ".config/micro/bindings.json".text = ''
      {
          "Alt-/": "lua:comment.comment",
          "CtrlUnderscore": "lua:comment.comment",
          "Alt-z": "command:set wordwrap on,command:set softwrap on",
          "Alt-Z": "command:set wordwrap off,command:set softwrap off"
      }
    '';
  };


  home.sessionVariables = {
    MICRO_TRUECOLOR = 1;  # required for some micro color schemes
  };


}
