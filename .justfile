_default: help

# List all recipes (or just run `just`).
[group('0. Help')]
help:
    @just --list





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
update-all: update-flake update-system update-home

# `update-all` -> `reboot`
[group('1. Update System')]
update-all-reboot: update-all
    reboot





# "Deletes all unreachable store objects in the Nix store to clean up your system."
[group('2. Garbage Collection')]
clean-unreachable:
    @# For more info, see: https://nix.dev/manual/nix/2.18/command-ref/nix-collect-garbage.html
    nix-collect-garbage

# "Deletes old profiles, allowing potentially more store objects to be deleted because profiles are also garbage collection roots" (runs `just clean-unreachable` afterwards).
[group('2. Garbage Collection')]
clean-profiles:
    @# For more info, see: https://nix.dev/manual/nix/2.18/command-ref/nix-collect-garbage.html
    nix-collect-garbage --delete-old
    just clean-unreachable    # NOTE: I don't think you need this, but I add it just in case :3





# Search home manager man page.
[group('Misc Helper Recipes')]
search-home:
	man home-configuration.nix
