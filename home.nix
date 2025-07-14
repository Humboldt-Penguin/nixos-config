{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  pkgs-stable-unfree,
  pkgs-unstable-unfree,
  ...
}:



let
  /*
  The code below (in the `let` binding) allows you to force specific package(s) to use a certain commit hash. This is helpful when an update breaks a package or fails to compile, so you want to use an older version.
    - Code/explanation found here: https://stackoverflow.com/a/79021669
  */


  # /*
  # zed-editor 0.160.7
  #   - 241117 self-note: Trying to upgrade to 0.161.1 or 0.161.2 is forcing me to recompile a bunch of stuff, so I'm pinning zed to the latest-working commit (0.160.7) for the time-being.
  #   - https://github.com/NixOS/nixpkgs/commit/d0cab6aa5ab46c85a5489eec3bcf82c0a8faf6cc
  # */
  # pkgs_zeditor = import (pkgs.fetchFromGitHub {
  #   owner  = "NixOS";
  #   repo   = "nixpkgs";
  #   rev    = "d0cab6aa5ab46c85a5489eec3bcf82c0a8faf6cc";
  #   sha256 = "uAaV3aARNf48XTsaPvFov2zhhv4I7vBQ7AZ8lcRO9IE=";
  # }) {
  #   inherit (pkgs) system;
  # };
in



{
  imports = [
    ./nix-modules/apps/chromium/home.nix
    ./nix-modules/apps/kdeconnect/home.nix
    ./nix-modules/apps/localsend/home.nix
    ./nix-modules/apps/vscode/home.nix

    ./nix-modules/system/keyd/home.nix

    ./nix-modules/terminal/custom_scripts/home.nix
    ./nix-modules/terminal/git/home.nix
    ./nix-modules/terminal/kitty/home.nix
    ./nix-modules/terminal/micro/home.nix
    ./nix-modules/terminal/zoxide/home.nix
    ./nix-modules/terminal/zsh/home.nix
  ];


  home = {
    username = "lain";
    homeDirectory = "/home/lain";
    stateVersion = "24.05";   /* DO NOT CHANGE (see comment in git history for more info) */
  };


  /* Programs that don't require additional config (if that's required, move to a new entry in `/nix-modules/.../appname/`). */
  home.packages =

    (with pkgs; [

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')


      /* text editors */
      zed-editor

      /* meta-terminal tools */
      lf
      # dmenu    # p sure there's a better alternative now, maybe for wayland...?

      /* cli tools [think pipx] */
      wget
      trashy
      tldr
      rsync
      rclone
      nh

      /* nix-specific stuff (ew lol) */
      # alejandra

      /* usb tools (edit: use nix-shell or temporarily install when you need it, no need keeping it around forever) */
      # ventoy
      # gparted
      # exfatprogs

      /* gui: browser */
      tor-browser
      librewolf
      # brave

      /* gui: comms */
      vesktop
      signal-desktop

      /* gui: office */
      libreoffice
      onlyoffice-bin
      kdePackages.kolourpaint

      /* gui: media */
      mpv
      # simplescreenrecorder # not on wayland :(
      obs-studio # this is only for screen recording with audio, use KDE Spectacle (or maybe try flameshot at some point?) for screenshots and recordings without audio!

      freecad

    ])
    ++
    (with pkgs-unstable; [
      /* programming tools */
      just

      ## gui: media
      qbittorrent

      zotero

      kdePackages.kdenlive

    ])
    ++
    (with pkgs-unstable-unfree; [
      code-cursor
    ])
    ;





  # home.file = {
  #   /*
  #     General templates are:
  #       - ".dotfile".source = path/from/here;
  #       - ".dotfile".text = '' file content '';
  #   */

  #   # ".config/vesktop/settings/settings.json".source = dotfiles_raw/vencord-settings-backup-2024-08-28.json;
  #   /* NOTE: this does NOT work for apps (like vencord) which need writing access to the config file (unfortunately home manager creates read-only symlinks) -- i'll fix this some time in the future, but for now just manually load the config file lol */

  # };



  /* Environment variables (see original comment that was here in git history for more info) */
  home.sessionVariables = {
    # EDITOR = "emacs";
  };



  /* (this was here by default, I did not add this, do not remove) Let Home Manager install and manage itself. */
  programs.home-manager.enable = true;




  programs = {

    bash = {
      enable = true;
      bashrcExtra = ''
        PS1='$(if [ $SHLVL -gt 1 ]; then echo "($SHLVL) "; fi)'$PS1
      '';
      # shellAliases = {
      #   l = "ls -la";
      #   ".." = "cd ..";
      #   c = "clear";
      # };
    };

  };



}
