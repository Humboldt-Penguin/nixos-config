_default: help

[group('0. Help')]
[doc('List all recipes (or just run `just`).')]
help:
    @just --list --unsorted










# DEV NOTE: "A recipe can also have subsequent dependencies, which run immediately after the recipe and are introduced with an &&"
# ^ [source] https://just.systems/man/en/dependencies.html

[group('1. Update System')]
[doc('Rebuild system-level config (TODO: explain this better).')]
rebuild-system: && _update_nixos_generation_number _update_system_package_list
    @# sudo nixos-rebuild switch --flake .
    nh os switch .


[group('1. Update System')]
[doc('Rebuild home-level config (TODO: explain this better).')]
rebuild-home: && _update_hm_generation_number _update_hm_package_list
    @# home-manager switch --flake .
    nh home switch .


[group('1. Update System')]
[doc('`rebuild-system` -> `rebuild-home`')]
rebuild-all: rebuild-system rebuild-home


[group('1. Update System')]
[doc('Update flake (TODO: explain this better).')]
update-flake:
    nix flake update    # not sure if you need sudo...?


[group('1. Update System')]
[doc('Update flake then discard any changes.')]
check-flake-updates:
    #!/usr/bin/env bash
    set -euo pipefail

    uptime

    if ! git diff --quiet HEAD -- flake.lock; then
        git restore flake.lock
    fi

    just update-flake

    if ! git diff --quiet HEAD -- flake.lock; then
        git restore flake.lock
    else
        echo "No updates detected in flake.lock"
    fi


[group('1. Update System')]
[doc('`update-flake` -> `rebuild-all`')]
update-all: _cache-sudo update-flake rebuild-all


[group('1. Update System')]
[doc('`update-all` -> commit any package/version/generation changes -> reboot')]
update-all-reboot: update-all
    #!/usr/bin/env bash
    set -euo pipefail

    if git diff --quiet HEAD -- docs/versioning/ flake.lock; then
        echo "No changes detected in docs/versioning/ or flake.lock. Skipping git commit."
    else
        # echo "Changes detected in docs/versioning/ or flake.lock. Adding and committing."
        git add docs/versioning/ flake.lock
        git commit -m "Full update"
    fi

    sleep 10s # pause for 10s to review changes

    reboot





_cache-sudo:
    @sudo -v

## TODO: use something like `nv` to print the names/versions of upgraded packages to the `dirpath_versioning` directory with a timestamp (runs everytime we rebuild/update)

dirpath_versioning := 'docs/versioning/'
_mkpath_versioning:
    @mkdir -p {{dirpath_versioning}}

_update_nixos_generation_number: _mkpath_versioning
    #!/usr/bin/env bash
    set -euo pipefail
    nixos_generation=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | awk 'END {print $1}')
    echo "Generation # (NixOS) = $nixos_generation"
    echo "$nixos_generation" > {{dirpath_versioning}}.generation_nixos

_update_hm_generation_number: _mkpath_versioning
    #!/usr/bin/env bash
    set -euo pipefail
    hm_generation=$(home-manager generations | awk 'NR==1 {print $5}')
    echo "Generation # (home-manager) = $hm_generation"
    echo "$hm_generation" > {{dirpath_versioning}}.generation_home-manager

_update_hm_package_list: _mkpath_versioning
    home-manager packages > {{dirpath_versioning}}packages_home-manager.txt
    @# To learn more about this command, just run `home-manager`

_update_system_package_list: _mkpath_versioning
    @# format: "name-version", sorted by name
    nix-store --query --requisites /run/current-system | cut -d- -f2- | sort > {{dirpath_versioning}}packages_system.txt
    @# format: "hash-name-version", sorted by name
    nix-store --query --requisites /run/current-system | sed 's|/nix/store/||' | sort -t '-' -k2 > {{dirpath_versioning}}packages_system_with-hash.txt

    @# ^ Inspiration: https://functor.tokyo/blog/2018-02-20-show-packages-installed-on-nixos










# [group('2. Garbage Collection')]
# [doc('"Deletes all unreachable store objects in the Nix store to clean up your system."')]
# clean-dangling:
#     @# For more info, see: https://nix.dev/manual/nix/2.18/command-ref/nix-collect-garbage.html
#     sudo nix-collect-garbage

# [group('2. Garbage Collection')]
# [doc('"Deletes old profiles, allowing potentially more store objects to be deleted because profiles are also garbage collection roots."')]
# clean-nixos:
#     @# Further reading: https://nix.dev/manual/nix/2.18/command-ref/nix-collect-garbage.html
#     sudo nix-collect-garbage --delete-old
#     @# DEV NOTE: I don't think you need `clean-dangling` afterwards, whenever I do it doesn't remove anything

# [group('2. Garbage Collection')]
# [doc('Delete all old `home-manager` generations (exceupt current).')]
# clean-hm:
#     @# Further reading: run `home-manager` and it'll autoprint the help message.
#     home-manager expire-generations "-1 second"

# [group('2. Garbage Collection')]
# [doc('`clean-hm` -> `clean-nixos`.')]
# clean-all: _cache-sudo clean-hm clean-nixos

[group('2. Garbage Collection')]
[doc('Clean root profiles and call a store gc.')]
clean-all:
    nh clean all










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

[group('Misc Helper Recipes')]
[doc('Crash chromium so when you relaunch, you get "restore tabs" dialog (remembers multiple desktops and PWAs).')]
kill-chromium:
    pkill -9 chromium










[doc('since when?')]
nixos-btw: _cache-sudo
    #!/usr/bin/env bash
    set -euo pipefail
    DEVICE=$(df / | awk 'NR==2 {print $1}')
    echo
    sudo tune2fs -l "$DEVICE" | grep 'Filesystem created:'
    echo
    echo "(Despite everything, it's still you.)"
    echo
