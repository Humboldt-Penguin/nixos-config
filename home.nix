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
        # vscodium

        ## meta tools
        keyd

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
        ## programming tools
        # uv
        just

        ## text editors
        zed-editor
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
        l = "ls -la";
        ll = "ls -l";
        ".." = "cd ..";
        c = "clear";
        "c." = "codium .";
        "d." = "nohup dolphin . &";
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

    vscode = {
    ## Full options list (todo stuff like keybindings eventually): https://home-manager-options.extranix.com/?query=vscode&release=release-24.05
      enable = true;
      package = pkgs-unstable.vscodium;

      userSettings = {
        /* `keyd` compatibility...
                - This is a workaround for my `keyd` custom hotkeys -- specifically, my hotkeys for navigation involve holding "alt", which has unintended side effects in editors like vscode/vscodium since default behavior is that holding alt highlights stuff in the menu bar. To fix this, I add the four settings above to my 'settings.json'.
                - Also note that there's some room for flexibility here (e.g. you can enable mnemonics, I just don't use it personally).
        */
        "window.customMenuBarAltFocus" = false;
        "window.enableMenuBarMnemonics" = false;
        "window.menuBarVisibility" = "compact";
        "window.titleBarStyle" = "custom";

        /* Aesthetic stuff: */
        "workbench.sideBar.location" = "right";
        "window.commandCenter" = false;
        "workbench.layoutControl.enabled" = false;
        # "workbench.colorTheme" = "Ayu Dark Bordered";
        "workbench.colorTheme" = "Gruvbox Dark Hard";
        "workbench.tree.indent" = 24;    ## Increase indent width in sidebar file explorer (default value is 8).

        /* Functional behavior: */
        "files.trimTrailingWhitespace" = true;
        # "window.closeWhenEmpty" = true;    ## Nah, when programming I like periodically closing all my tabs -- use `C-S-w` instead

        /* Jupyter stuff: */
        "jupyter.askForKernelRestart" = false;
        "notebook.lineNumbers" = "on";
      };


      /*
        [RESOURCES]
          - Search GitHub: https://github.com/search?q=language%3Anix+vscode+keybindings&type=code
      */
      keybindings = [

        /* C-r -- restart kernel */
        {
          command = "jupyter.restartkernel";
          key = "ctrl+r";
          when = "notebookEditorFocused";
        }
        { key = "ctrl+r"; command = "-workbench.action.openRecent"; }    ## Unbind default

        /* C-A-r -- restart kernel and run up to selected cell */
        {
          command = "jupyter.restartkernelandrunuptoselectedcell";
          key = "ctrl+alt+r";
          when = "notebookEditorFocused";
        }
        { key = "ctrl+alt+r"; command = "-revealFileInOS"; when = "!editorFocus"; }    ## Unbind default
      ];


      /*
        [RESOURCES]
          - Nix wiki (basic explanation/boilerplate): https://nixos.wiki/wiki/VSCodium
          - Search GitHub (example): https://github.com/search?q=language%3Anix+vscode-extension-github-copilot&type=code
      */
      extensions =
        /* [1/2] `pkgs-[un]stable.vscode-extensions`
          - These are Nix expressions maintained by nix-community: https://github.com/nix-community/nix-vscode-extensions
            - Search stable:   https://search.nixos.org/packages?query=vscode-extensions
            - Search unstable: https://search.nixos.org/packages?channel=unstable&query=vscode-extensions
        */
        (with pkgs.vscode-extensions; [
        ])
        ++
        (with pkgs-unstable.vscode-extensions; [
          /* Syntax */
          jnoortheen.nix-ide
          nefrob.vscode-just-syntax

          /* Jupyter */
          ms-toolsai.jupyter
          ms-toolsai.jupyter-renderers
          ms-toolsai.jupyter-keymap

          /* Themes (https://vscodethemes.com/?type=dark) */
          teabyii.ayu
          jdinhlife.gruvbox
        ])
        ++
        (with pkgs-unstable-unfree.vscode-extensions; [
          github.copilot
          github.copilot-chat
        ])
        ++
        /* [2/2]
          - These are straight from the VSCode marketplace: https://marketplace.visualstudio.com/
            - Search GitHub for examples: https://github.com/search?q=extensionsFromVscodeMarketplace&type=code
        */
        pkgs-unstable.vscode-utils.extensionsFromVscodeMarketplace [
          {
            ## Link: https://open-vsx.org/extension/phil294/git-log--graph
            name = "git-log--graph";
            publisher = "phil294";
            version = "0.1.15";
            sha256 = "sha256-lvjDkvXSX7rw7HyyK3WWQLnGezvL6FPEgtjIi8KWkU0=";
          }
          {
            ## Link: https://marketplace.visualstudio.com/items?itemName=stackbreak.comment-divider
            name = "comment-divider";
            publisher = "stackbreak";
            version = "0.4.0";
            sha256 = "sha256-L8htDV8x50cbmRxr4pDlZHSW56QRnJjlYTps9iwVkuE=";
          }
        ];

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
