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


# Search home manager man page.
search-home:
	man home-configuration.nix