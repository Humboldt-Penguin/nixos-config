{
  config,
  pkgs,
  ...
}:

{
  /*
    Enable + configure keyd.
      - [RESOURCES:]
        - NixOS wiki (helpful but not comprehensive): https://wiki.nixos.org/wiki/Keyd
      - [REFERENCE:]
        - Check status (if it's running/failed, uptime, errors with conf file, etc.) with: `sudo systemctl status keyd` (or `restart` instead of `status).
      - [SELF NOTES:]
        - There's some extra companion config in `home.nix` to write a home file to allow unicode symbols like em dash. When I modularize everything, I'll make that more spatially associated with this stuff.
  */
  services.keyd = {
    enable = true;
    /* The following writes to a conf file in "/etc/keyd/". */
    keyboards = {
      keybinds = {        /* this is just the name of the config file, doesn't really matter */
        ids = [ "*" ];    /* apply to all keyboards */
        settings = {

          /* TEMP, REVERT ONCE KEYBOARD IS FIXED */
          main = {
            # capslock = "leftshift";
            capslock = "overload(shift, capslock)"; # hold for shift, tap for capslock
            leftshift = "noop";
          };

          alt = {
            i = "up";
            j = "left";
            k = "down";
            l = "right";

            u = "home";
            o = "end";

            y = "pageup";
            p = "pagedown";

            "-" = "—";
            # "=" = "⟹";    # todo (mid priority): this gives error "ERROR: line 8: invalid key or action"

            n = "macro(A-left)";
            m = "macro(A-down)";
            "," = "macro(A-up)";
            "." = "macro(A-right)";
          };
        };
      };
    };
  };

  /* "Optional, but makes sure that when you type the make palm rejection work with keyd" (see nixos wiki for more info and github:keyd issue) */
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';

}
