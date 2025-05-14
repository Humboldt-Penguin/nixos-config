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
    vscode = {
    /* Full options list (todo stuff like keybindings eventually): https://home-manager-options.extranix.com/?query=vscode&release=release-24.05 */



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
        "workbench.tree.indent" = 24;    ## Increase indent width in sidebar file explorer (default value is 8).
        "workbench.startupEditor" = "none";
        "editor.wordWrap" = "on";    ## Word wrap by default (prevents accidentally/maliciously hidden text)

        # "workbench.colorTheme" = "Ayu Dark Bordered";
        # "workbench.colorTheme" = "Gruvbox Dark Hard";
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";

        /* Functional behavior: */
        "files.trimTrailingWhitespace" = true;
        # "window.closeWhenEmpty" = true;    ## Nah, when programming I like periodically closing all my tabs -- use `C-S-w` instead
        "files.insertFinalNewline" = true;
        "window.zoomLevel" = -1;  ## Zoom out a bit (default is 0).
        "window.zoomPerWindow" = false;  ## Fix bug where opening a second instance of vscode will "forget" what you used last time and reset zoom to 0.

        /* Jupyter stuff: */
        "jupyter.askForKernelRestart" = false;
        "notebook.lineNumbers" = "on";

        # /* Disable copilot: */
        # "github.copilot.enable" = {
        #   "*" = false;
        # };

        /* Enable copilot for markdown files: */
        "github.copilot.enable" = {
          "markdown" = true;
        };

        /* autoDocstring extension */
        "autoDocstring.docstringFormat" = "numpy";



        /* `mkdocs-material` recommended YAML schema validation (source: https://squidfunk.github.io/mkdocs-material/creating-your-site/ ) */
        "yaml.schemas" = {
          "https://squidfunk.github.io/mkdocs-material/schema.json" = "mkdocs.yml";
        };
        "yaml.customTags" = [
          "!ENV scalar"
          "!ENV sequence"
          "!relative scalar"
          "tag:yaml.org,2002:python/name:material.extensions.emoji.to_svg"
          "tag:yaml.org,2002:python/name:material.extensions.emoji.twemoji"
          "tag:yaml.org,2002:python/name:pymdownx.superfences.fence_code_format"
          "tag:yaml.org,2002:python/object/apply:pymdownx.slugs.slugify mapping"
        ];
        "redhat.telemetry.enabled" = false;  ## this is to curb the `redhat.vscode-yaml` extension



        /* LaTeX */

        "latex-workshop.latex.autoBuild.run" = "onSave";

        "latex-workshop.formatting.latex" = "tex-fmt";
        "latex-workshop.formatting.tex-fmt.args" = [
          "--nowrap"
          "--tabsize" "4"
        ];

        "[latex]" = {
          "editor.formatOnSave" = true;
          "editor.defaultFormatter" = "James-Yu.latex-workshop";
        };




      };





      keybindings = [
        /*
          [RESOURCES]
            - Search GitHub: https://github.com/search?q=language%3Anix+vscode+keybindings&type=code
        */

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

        /* C-S-/ -- block comment */
        {
          command = "editor.action.blockComment";
          key = "ctrl+shift+/";
          when = "editorTextFocus && !editorReadonly";
        }

        /* C-A-d -- generate & insert docstring (extension: autoDocstring) */
        {
          command = "autoDocstring.generateDocstring";
          key = "ctrl+alt+d";
          when = "editorTextFocus";
        }
        { key = "ctrl+shift+2"; command = "-autoDocstring.generateDocstring"; when = "editorTextFocus"; }    ## Unbind default

        /* A-\ -- align vertically (extension) */
        {
          command = "extension.alignVertically";
          key = "alt+\\";
        }
        { key = "alt+\\"; command = "-editor.action.inlineSuggest.trigger"; when = "editorTextFocus && !editorHasSelection && !inlineSuggestionsVisible"; }    ## Unbind default

        /* A-c -- horizontal line (extension) */
        {
          command = "comment-divider.insertSolidLine";
          key = "alt+c";
          when = "editorTextFocus";
        }

        /* C-k g -- open extension: git log graph */
        {
          command = "git-graph.view";
          key = "ctrl+k g";
        }

      ];





      extensions =
        /*
          [RESOURCES]
            - Nix wiki (basic explanation/boilerplate): https://nixos.wiki/wiki/VSCodium
            - Search GitHub (example): https://github.com/search?q=language%3Anix+vscode-extension-github-copilot&type=code
        */


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
          redhat.vscode-yaml
          tamasfe.even-better-toml

          /* Python/Jupyter */
          ms-python.python
          ms-toolsai.jupyter
          ms-toolsai.jupyter-renderers
          ms-toolsai.jupyter-keymap

          /* LaTeX */
          james-yu.latex-workshop

          /* Themes (https://vscodethemes.com/?type=dark) */
          teabyii.ayu
          jdinhlife.gruvbox
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons

          /* Misc */
          njpwerner.autodocstring  # Python docstring generator (https://github.com/NilsJPWerner/autoDocstring )
        ])
        ++
        (with pkgs-unstable-unfree.vscode-extensions; [
          github.copilot
          github.copilot-chat

          mhutchie.git-graph
        ])
        ++


        /* [2/2]
          - These are straight from the VSCode marketplace: https://marketplace.visualstudio.com/
            - Search GitHub for examples: https://github.com/search?q=extensionsFromVscodeMarketplace&type=code
        */
        pkgs-unstable.vscode-utils.extensionsFromVscodeMarketplace [
          # {
          #   ## Link: https://open-vsx.org/extension/phil294/git-log--graph
          #   name = "git-log--graph";
          #   publisher = "phil294";
          #   version = "0.1.23";
          #   sha256 = "sha256-i18ot6O9n5ooJ9jWccLq3KEo5UoonEzPHG0e90INX4Y=";
          # }
          {
            ## Link: https://marketplace.visualstudio.com/items?itemName=stackbreak.comment-divider
            name = "comment-divider";
            publisher = "stackbreak";
            version = "0.4.0";
            sha256 = "sha256-L8htDV8x50cbmRxr4pDlZHSW56QRnJjlYTps9iwVkuE=";
          }
          {
            ## Link: https://marketplace.visualstudio.com/items?itemName=matthewthorning.align-vertically
            name = "align-vertically";
            publisher = "matthewthorning";
            version = "0.2.0";
            sha256 = "sha256-kf3FpOm2E6Cyi2UFExgrGf03mkEMeIURul4GaRXAglg=";
          }
          {
            ## Link: https://marketplace.visualstudio.com/items?itemName=TakumiI.markdowntable
            name = "markdowntable";
            publisher = "TakumiI";
            version = "0.13.0";
            sha256 = "sha256-N1FZbDFiX5S+qKrtWpA+zGUhC81db5JiqcSPxeHmkhE=";
          }
        ];





    };
  };

}
