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

      /* Due to a bug with Chromium 140 on Wayland, we temporarily force X11 backend: https://chatgpt.com/c/68c74151-fa1c-8321-b482-e435367a0dcb */
      commandLineArgs = [
        "--ozone-platform=x11"
        "--force-device-scale-factor=1"
      ];

    };
  };

}
