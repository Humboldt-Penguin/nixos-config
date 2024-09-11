_default: help

# List all recipes (or just run `just`).
help:
    just --list



# Update flake (TODO: explain this better).
update-flake:
    nix flake update    # not sure if you need sudo...?


# Rebuild system-level config (TODO: explain this better).
update-system:
    sudo nixos-rebuild switch --flake .


# Rebuild home-level config (TODO: explain this better).
update-home:
    home-manager switch --flake .


update-all: update-flake update-system update-home

update-all-reboot: update-all
    reboot

# "Deletes all unreachable store objects in the Nix store to clean up your system."
clean-unreachable:
    @# For more info, see: https://nix.dev/manual/nix/2.18/command-ref/nix-collect-garbage.html
    nix-collect-garbage

# "Deletes old profiles, allowing potentially more store objects to be deleted because profiles are also garbage collection roots" (runs `just clean-unreachable` afterwards).
clean-profiles:
    @# For more info, see: https://nix.dev/manual/nix/2.18/command-ref/nix-collect-garbage.html
    nix-collect-garbage --delete-old
    just clean-unreachable    # NOTE: I don't think you need this, but I add it just in case :3

# Search home manager man page.
search-home:
	man home-configuration.nix
