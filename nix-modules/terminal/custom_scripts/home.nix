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
  /* NOTE: to make custom scripts in `~/.local/bin` available, you must add `export PATH="$HOME/.local/bin:$PATH"` to `programs.zsh.initExtra`. */
  home.file = {

    /*
      This command takes a file path like "foo.txt" and writes the SHA256 hash to a file named "foo.txt.sha256".
    */
    ".local/bin/write-sha256" = {
      executable = true;
      source = ./src/write-sha256;
    };

    /*
      This command prevents system sleeping for a specified amount of time (e.g. '20m', '1h', etc.)
    */
    ".local/bin/stay-awake" = {
      executable = true;
      source = ./src/stay-awake;
    };

  };
}
