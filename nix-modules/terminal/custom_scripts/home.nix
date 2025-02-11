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

    /*
      NOTE: to make custom scripts in `~/.local/bin` available, you must add `export PATH="$HOME/.local/bin:$PATH"` to `programs.zsh.initExtra`.
      This command takes a file path like "foo.txt" and writes the SHA256 hash to a file named "foo.txt.sha256".
    */
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
