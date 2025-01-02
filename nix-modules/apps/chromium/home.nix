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
    chromium = {

      enable = true;
      package = pkgs.ungoogled-chromium;

      commandLineArgs = [
        "--force-device-scale-factor=1"
      ];

    };
  };

}
