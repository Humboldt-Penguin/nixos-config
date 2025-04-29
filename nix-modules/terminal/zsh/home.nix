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
    ".config/oh-my-posh/zen.toml".source = ./zen.toml;
  };



  programs = {


    zsh = {
      enable = true;

      /* Make zsh init with a custom-written oh-my-posh config file written by home-manager (see `home.file = ...`). */
      initExtra = ''
        eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config $HOME/.config/oh-my-posh/zen.toml)"
        export PATH="$HOME/.local/bin:$PATH"    # make custom scripts in `~/.local/bin` available

        # Ensure `nix-shell` and `nix develop` use the user's shell — note the latter doesn't work when a flake uses `buildFHSEnv`, see "RedPlanet" flake for workaround.
        nix-shell() {
          command nix-shell --run "$SHELL" "$@"
        }
        nix() {
          case "$1" in
            develop)
              shift
              command nix develop -c "$SHELL" "$@"
              ;;
            *)
              command nix "$@"
              ;;
          esac
        }
      '';

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        /* system */
        "l" = "ls -la";
        "ll" = "ls -l";
        ".." = "cd ..";
        "c" = "clear";
        "shlvl" = "echo $SHLVL";

        /* programs */
        "c." = "codium .";
        "j" = "just";

        /* misc util */
        "inhibit" = "systemd-inhibit sleep";
          /*
          - NOTE on `inhibit`: since this is using the `sleep` command, time can be formatted as:
            - SUFFIX may be 's' for seconds (the default), 'm' for minutes, 'h' for hours or 'd' for days.
            - NUMBER need not be an integer.
            - Given two or more arguments, pause for the amount of time specified by the *sum* of their values.
          */

        /* git */
        "gs" = "git status";
        "ga" = "git add";
        "gaa" = "git add --all";
        "gc" = "git commit";
        "gcm" = "git commit -m";
        "gca" = "git commit --amend";
        "gd" = "git diff";
        "gds" = "git diff --staged";
        "gl" = "git log";
        "glo" = "git log --oneline --graph";
        "glg" = "git log --grep";
        "gp" = "git push";
        "gpa" = "git push --all";
      };

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
    };



    oh-my-posh = {
      enable = true;
      /* This makes sure that zsh is installed/enabled, but prevents automatically adding `eval init zsh` to the '.zshrc', so that I can manually add it with `programs.zsh.initExtra` in a way that points to my own config file. */
      enableZshIntegration = false;
    };


  };

}
