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


    zsh = {
      enable = true;

      /* Make zsh init with a custom-written oh-my-posh config file written by home-manager (see `home.file = ...`). */
      initExtra = ''
        eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config $HOME/.config/oh-my-posh/zen.toml)"
      '';

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        "l"     = "ls -la";
        "ll"    = "ls -l";
        ".."    = "cd ..";
        "c"     = "clear";
        "c."    = "codium .";
        "shlvl" = "echo $SHLVL";
        "j"     = "just";
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
