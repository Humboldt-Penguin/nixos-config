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
        colorscheme = "gruvbox";
        hltaberrors = true;
        keepautoindent = true;
        tabstospaces = true;
      };

    };
  };

}
