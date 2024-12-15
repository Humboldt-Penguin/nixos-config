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
    ./nix-modules/chromium/home.nix
    ./nix-modules/keyd/home.nix
    ./nix-modules/vscode/home.nix
    ./nix-modules/zsh/home.nix
  ];


  home = {
    username = "lain";
    homeDirectory = "/home/lain";
    stateVersion = "24.05";   /* DO NOT CHANGE (see comment in git history for more info) */
  };


  home.packages =

    (with pkgs; [

        # # You can also create simple shell scripts directly inside your
        # # configuration. For example, this adds a command 'my-hello' to your
        # # environment:
        # (pkgs.writeShellScriptBin "my-hello" ''
        #   echo "Hello, ${config.home.username}!"
        # '')

        /* text editors */
        micro
        zed-editor


        /* meta-terminal tools */
        kitty
        lf
        # zoxide
        # fzf
        # dmenu    # p sure there's a better alternative now, maybe for wayland...?


        /* cli tools [think pipx] */
        wget
        trashy
        tldr
        rsync
        rclone
        # ffmpeg
        # ytarchive
        # yt-dlp

        /* nix-specific stuff */
        # alejandra


        /* programming tools */
        git
        # just


        /* usb tools */
        # ventoy
        # gparted
        # exfatprogs


        /* gui: browser */
        librewolf
        # brave


        /* gui: comms */
        vesktop


        /* gui: office */
        libreoffice
        onlyoffice-bin
        kdePackages.kolourpaint

        /* gui: media */
        mpv
        # simplescreenrecorder # not on wayland :(
        obs-studio # this is only for screen recording with audio, use KDE Spectacle (or maybe try flameshot at some point?) for screenshots and recordings without audio!

      ])
      ++
      (with pkgs-unstable; [
        /* programming tools */
        # uv
        just

        /* text editors */
        # zed-editor  ## moved to stable in 24.11 so no need to constantly update on unstable :3

        ## gui: media
        qbittorrent
      ])
      # ++
      # (with pkgs_zeditor; [
      #   /* text editors */
      #   zed-editor
      # ])
      ;





  home.file = {
    /*
      General templates are:
        - ".dotfile".source = path/from/here;
        - ".dotfile".text = '' file content '';
    */

    # ".config/vesktop/settings/settings.json".source = dotfiles_raw/vencord-settings-backup-2024-08-28.json;
    /* NOTE: this does NOT work for apps (like vencord) which need writing access to the config file (unfortunately home manager creates read-only symlinks) -- i'll fix this some time in the future, but for now just manually load the config file lol */

    ".config/micro/bindings.json".text = ''
      {
          "Alt-/": "lua:comment.comment",
          "CtrlUnderscore": "lua:comment.comment",
          "Alt-z": "command:set wordwrap on,command:set softwrap on",
          "Alt-Z": "command:set wordwrap off,command:set softwrap off"
      }
    '';

    ".config/oh-my-posh/zen.toml".source = dotfiles/.config/oh-my-posh/zen.toml;

  };



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

    kitty = {
      enable = true;
      themeFile = "gruvbox-dark-hard";
      settings = {
        cursor_shape = "beam";
        font_size = 9;
      };
    };

    micro = {
      enable = true;
      settings = {
        colorscheme = "gruvbox";
        hltaberrors = true;
        keepautoindent = true;
        tabstospaces = true;
      };
    };

    git = {
      enable = true;

      userName = "Zain Eris Kamal";
      userEmail = "zain.eris.kamal@rutgers.edu";

      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        core = {
          # editor = "codium --wait --new-window";    # slow bleh
          editor = "micro";
        };
      };
    };

  };


}
