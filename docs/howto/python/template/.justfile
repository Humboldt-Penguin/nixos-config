_default: help

# List all recipes (or just run `just`).
[group('0. Help')]
help:
    @just --list





## For more info on `nix develop`, see: https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-develop.html
## > `nix develop` - run a bash shell that provides the build environment of a derivation

# Send command to be executed in the development environment (without modifying current shell).
[group('1. Access UV Development Environment')]
run-in-devshell your-command:
    nix develop --command "{{your-command}}"


## The next two commands (`activate` and `deactivate` devshell) are based on the assumption that if $SHLVL > 1 then we're already in a nix interactive development shell. See more discussion in the following two links:
## [1] https://discourse.nixos.org/t/custom-prompts-or-shell-depth-indicator-for-nix-shell-nix-develop/29942
## [2] https://github.com/NixOS/nix/issues/6677

# Activate interactive development shell (need to `exit` or `just deactivate-devshell` when done).
[group('1. Access UV Development Environment')]
activate-devshell:
    #!/usr/bin/env bash
    set -euxo pipefail
    if [ -z "$SHLVL" ]; then
      echo "Environment variable \$SHLVL not found, this is unexpected, not sure what to do."
      echo "Exiting without any changes."
      exit 1
    elif [ "$SHLVL" -eq 1 ]; then
      nix develop
      echo "Successfully activated interactive development shell."
    else
      echo "You are probably already in a development shell (\$SHLVL = $SHLVL)."
      echo "Exiting without any changes."
    fi


# Deactivate interactive development shell.
[group('1. Access UV Development Environment')]
deactivate-devshell:
    #!/usr/bin/env bash
    set -euxo pipefail
    if [ -z "$SHLVL" ]; then
      echo "Environment variable \$SHLVL not found, this is unexpected, not sure what to do."
      echo "Exiting without any changes."
      exit 1
    elif [ "$SHLVL" -eq 1 ]; then
      echo "You are probably already in your native shell (\$SHLVL = $SHLVL)."
      echo "Exiting without any changes."
    else
      exit
      echo "Successfully deactivated interactive development shell, hopefully you're back in your native shell (\$SHLVL = $SHLVL)."
    fi

