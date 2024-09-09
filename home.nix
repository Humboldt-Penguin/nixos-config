{ config, pkgs, ... }:

{

  home = {
    username = "lain";
    homeDirectory = "/home/lain";
    stateVersion = "24.05"; # Please read the comment (see git history) before changing.
  };


  home.packages = with pkgs; [

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    ## text editors
    micro
    vscodium
    
    
    ## meta-terminal tools
    kitty
    lf
    # zoxide
    # fzf
    # dmenu    # p sure there's a better alternative now, maybe for wayland...?
    
    
    ## cli tools [think pipx]
    wget
    trashy
    tldr
    rsync
    rclone
    ffmpeg
    ytarchive
    yt-dlp


    ## programming tools
    git
    just
    
    
    ## usb tools
    ventoy
    gparted
    exfatprogs


    ## gui: browser
    librewolf
    ungoogled-chromium # chrome://ungoogled-first-run
    brave

    
    ## gui: comms
    vesktop

    
    ## gui: office
    libreoffice
    onlyoffice-bin
    
    ## gui: media
    mpv
    # simplescreenrecorder # not on wayland :(
    obs-studio # this is only for screen recording with audio, use KDE Spectacle (or maybe try flameshot at some point?) for screenshots and recordings without audio!
    
    

  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';


    # ".config/vesktop/settings/settings.json".source = dotfiles_raw/vencord-settings-backup-2024-08-28.json;
    ## NOTE: this does NOT work for apps (like vencord) which need writing access to the config file (unfortunately home manager creates read-only symlinks) -- i'll fix this some time in the future, but for now just manually load the config file lol

    ".config/micro/bindings.json".text = ''
      {
          "Alt-/": "lua:comment.comment",
          "CtrlUnderscore": "lua:comment.comment",
          "Alt-z": "command:set wordwrap on,command:set softwrap on",
          "Alt-Z": "command:set wordwrap off,command:set softwrap off"
      }
    '';
    
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/lain/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };



  programs.home-manager.enable = true;




  programs = {

    # bash = {
    #   enable = true;
    #     shellAliases = {
    #       l = "ls -l";
    #       ".." = "cd ..";
    #       c = "clear";
    #     };
    # };

    kitty = {
      enable = true;
      theme = "Gruvbox Dark Hard";
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
          editor = "codium --wait --new-window";
        };
      };
    };
    
    # chromium = {
    #   enable = true;
    #   package = pkgs.ungoogled-chromium;
    #   defaultSearchProviderSearchURL = "https://duckduckgo.com/?t=h_&q={searchTerms}";
    # };

  };


}
