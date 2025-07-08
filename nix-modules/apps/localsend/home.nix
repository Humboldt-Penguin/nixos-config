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

  home.packages =
    (with pkgs-unstable; [
      localsend
    ])
    ;

}
