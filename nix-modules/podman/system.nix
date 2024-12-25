{
  config,
  pkgs,
  ...
}:

{
  /*
    - Docs:
      - https://wiki.nixos.org/wiki/Podman
    - Extra stuff:
      - Note that home-manager also has options for podman, but I'm not sure what purpose they serve and how they integrate with the system-wide podman config below.
        - https://home-manager-options.extranix.com/?query=podman&release=release-24.11
      - If you want to use Docker instead...
        - Official docs: https://wiki.nixos.org/wiki/Docker
          - TLDR just add:
            ```
            virtualisation.docker.enable = true;
            users.users.lain.extraGroups = [ "docker" ];
            ```
  */

  /*
    Enable common container config files.
      - This is the MINIMUM required to use podman, else you encounter an error where you're missing `/etc/containers/policy.json`.
  */
  virtualisation.containers.enable = true;


  /* Enable podman system-wide. Otherwise, enable it in a development shell. */
  # virtualisation.podman = {
  #   enable = true;
  #   dockerCompat = true;  /* Create a `docker` alias for podman, to use it as a drop-in replacement. */
  # };
  # users.users.lain.extraGroups = [ "podman" ];

}
