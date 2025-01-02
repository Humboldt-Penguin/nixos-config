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
  home.packages = [
    pkgs.keyd
  ];

  home.file = {
    /* Note: the rest of keyd config (enable, install, & remaps/keybinds) is in "configuration.nix", this line simply enables unicode support (e.g. em dash "—") -- to understand the rationale, open `man keyd` and search (press "/") for "unicode support", or look straight into the repo: https://github.com/rvaiya/keyd/blob/master/docs/keyd.scdoc */
    ".XCompose".text = builtins.readFile (pkgs.keyd + "/share/keyd/keyd.compose");
  };
}
