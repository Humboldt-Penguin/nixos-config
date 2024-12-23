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

    /* Write SHA256 hash of a file to a text file with the same name but with a ".sha256" extension */
    ".local/bin/write-sha256" = {

      executable = true;
      text = ''
        #!/usr/bin/env bash

        if [ "$#" -ne 1 ]; then
          echo "Usage: write-sha256 <filename>"
          exit 1
        fi

        if [ -f "$1" ]; then
          sha256sum "$1" > "$1".sha256
        else
          echo "Error: $1 is not a file"
          exit 1
        fi
      '';

    };


  };

}
