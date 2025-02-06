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



  programs = {
    micro = {

      enable = true;
      package = pkgs.micro;

      settings = {
        /*
        - list of themes: https://github.com/zyedidia/micro/tree/master/runtime/colorschemes (no catppuccin uweh!!)
        - alternatively, ctrl+e then `help colors` for a longer explanation / documentation
        */
        # colorscheme = "gruvbox";
        colorscheme = "twilight";
        hltaberrors = true;
        keepautoindent = true;
        tabstospaces = true;
      };

    };
  };

}
