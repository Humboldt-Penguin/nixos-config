{ config, pkgs, pkgs-unstable, ... }:

{

  home = {
    username = "lain";
    homeDirectory = "/home/lain";
    stateVersion = "24.05"; # Please read the comment (see git history) before changing.
  };


  home.packages = 
    
    (with pkgs; [

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
        
        ## nix-specific stuff
        # alejandra


        ## programming tools
        git
        # just
        
        
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
        
      ])
      
      ++
      
      (with pkgs-unstable; [
        # uv
        just
      ]);
    


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

    ".config/oh-my-posh/zen.toml".source = dotfiles/.config/oh-my-posh/zen.toml;

    ## Note: the rest of keyd config (enable, install, & remaps/keybinds) is in "configuration.nix", this line simply enables unicode support (e.g. em dash "—") -- to understand the rationale, open `man keyd` and search (press "/") for "unicode support", or look straight into the repo: https://github.com/rvaiya/keyd/blob/master/docs/keyd.scdoc
    ".XCompose".text = builtins.readFile (pkgs.keyd + "/share/keyd/keyd.compose");
    /*
      My keymaps for navigation involve holding "alt", which has unintended side effects in editors like vscode/vscodium since default behavior is that holding alt highlights stuff in the menu bar. To fix this, I add the following to my "settings.json":

        ```json
        {
            "window.customMenuBarAltFocus": false,
            "window.enableMenuBarMnemonics": false,
            "window.menuBarVisibility": "compact",
            "window.titleBarStyle": "custom"
        }
        ```

      Note that there's some room for flexibility here (e.g. you can enable mnemonics, I just don't use it personally).

      TODO 1: Make it so these settings are added declaratively via home-manager.
      TODO 2: Eventually modularize my entire config and group all the keyd stuff (so it's not scattered across both "configuration.nix" and "home.nix").
    */
    
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



  # Let Home Manager install and manage itself.
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

    zsh = {
      enable = true;

      ## Make zsh init with a custom-written oh-my-posh config file written by home-manager (see `home.file = ...`).
      initExtra = ''
        eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config $HOME/.config/oh-my-posh/zen.toml)"
      '';

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        l = "ls -l";
        ll = "ls -la";
        ".." = "cd ..";
        c = "clear";
      };

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };

    };

    oh-my-posh = {
      enable = true;
      
      ## This makes sure that zsh is installed/enabled, but prevents automatically adding `eval init zsh` to the '.zshrc', so that I can manually add it with `programs.zsh.initExtra` in a way that points to my own config file.
      enableZshIntegration = false;
    };

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
