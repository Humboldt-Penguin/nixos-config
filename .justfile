_default: help

[group('0. Help')]
[doc('List all recipes (or just run `just`).')]
help:
    @just --list --unsorted



## TODO: rename 'update' commands to differentiate between 'update' and 'rebuild' commands (i initially differentiated so they'd be alphabetical, but now default command is unsorted!!!)

[group('1. Update System')]
[doc('Update flake (TODO: explain this better).')]
update-flake:
    nix flake update    # not sure if you need sudo...?

[group('1. Update System')]
[doc('Rebuild system-level config (TODO: explain this better).')]
update-system:
    sudo nixos-rebuild switch --flake .

[group('1. Update System')]
[doc('Rebuild home-level config (TODO: explain this better).')]
update-home:
    home-manager switch --flake .

[group('1. Update System')]
[doc('`update-flake` -> `update-system` -> `update-home`')]
update-all: _cache-sudo update-flake update-system update-home

[group('1. Update System')]
[doc('`update-all` -> `reboot`')]
update-all-reboot: update-all
    reboot


_cache-sudo:
    @sudo -v

# _get_nixos_generation:
#     sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | awk 'END {print $1}'
# _get_hm_generation:
#     home-manager generations | awk 'NR==1 {print $5}'

update_generation_numbers:
    #!/usr/bin/env bash
    set -euo pipefail
    nixos_generation=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | awk 'END {print $1}')
    hm_generation=$(home-manager generations | awk 'NR==1 {print $5}')
    echo "NixOS Generation: $nixos_generation"
    echo "Home Manager Generation: $hm_generation"
    echo "$nixos_generation" > docs/versioning/.nixos_generation
    echo "$hm_generation" > docs/versioning/.hm_generation


[group('2. Garbage Collection')]
[doc('"Deletes all unreachable store objects in the Nix store to clean up your system."')]
clean-unreachable:
    @# For more info, see: https://nix.dev/manual/nix/2.18/command-ref/nix-collect-garbage.html
    sudo nix-collect-garbage

[group('2. Garbage Collection')]
[doc('"Deletes old profiles, allowing potentially more store objects to be deleted because profiles are also garbage collection roots" (runs `just clean-unreachable` afterwards).')]
clean-profiles:
    @# For more info, see: https://nix.dev/manual/nix/2.18/command-ref/nix-collect-garbage.html
    sudo nix-collect-garbage --delete-old
    just clean-unreachable    # NOTE: I don't think you need this, but I add it just in case :3

## TODO: add command for cleaning home-manager profiles, prepend it to a 'clean-all' command.



[group('Misc Helper Recipes')]
[doc('Search home manager man page.')]
search-home:
	man home-configuration.nix

[group('Misc Helper Recipes')]
[doc('Print the path in `/nix/store/` for a given package.')]
get-path pkg:
    nix eval nixpkgs#{{pkg}}.outPath

[group('Misc Helper Recipes')]
[doc('Clear vscodium cache (its pretty good with allowing GUI/declared settings to coexist, but sometimes it gets confused).')]
codium-clear-cache:
    -trash ~/.vscode-oss
    -trash ~/.config/VSCodium
