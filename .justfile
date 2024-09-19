_default: help

# List all recipes (or just run `just`).
[group('0. Help')]
help:
    @just --list --unsorted





# Update flake (TODO: explain this better).
[group('1. Update System')]
update-flake:
    nix flake update    # not sure if you need sudo...?

# Rebuild system-level config (TODO: explain this better).
[group('1. Update System')]
update-system:
    sudo nixos-rebuild switch --flake .

# Rebuild home-level config (TODO: explain this better).
[group('1. Update System')]
update-home:
    home-manager switch --flake .

# `update-flake` -> `update-system` -> `update-home`
[group('1. Update System')]
update-all: _cache-sudo update-flake update-system update-home

# `update-all` -> `reboot`
[group('1. Update System')]
update-all-reboot: update-all
    reboot

_cache-sudo:
    @sudo -v



# "Deletes all unreachable store objects in the Nix store to clean up your system."
[group('2. Garbage Collection')]
clean-unreachable:
    @# For more info, see: https://nix.dev/manual/nix/2.18/command-ref/nix-collect-garbage.html
    sudo nix-collect-garbage

# "Deletes old profiles, allowing potentially more store objects to be deleted because profiles are also garbage collection roots" (runs `just clean-unreachable` afterwards).
[group('2. Garbage Collection')]
clean-profiles:
    @# For more info, see: https://nix.dev/manual/nix/2.18/command-ref/nix-collect-garbage.html
    sudo nix-collect-garbage --delete-old
    just clean-unreachable    # NOTE: I don't think you need this, but I add it just in case :3





# Search home manager man page.
[group('Misc Helper Recipes')]
search-home:
	man home-configuration.nix

# Print the path in `/nix/store/` for a given package.
[group('Misc Helper Recipes')]
get-path pkg:
    nix eval nixpkgs#{{pkg}}.outPath

# Clear vscodium cache (its pretty good with allowing GUI/declared settings to coexist, but sometimes it gets confused).
[group('Misc Helper Recipes')]
codium-clear-cache:
    -trash ~/.vscode-oss
    -trash ~/.config/VSCodium
