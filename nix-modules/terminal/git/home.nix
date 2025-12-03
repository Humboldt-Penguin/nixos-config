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


  /*
    RESOURCES:
    - home-manager options: https://home-manager-options.extranix.com/?query=git
    - nixos wiki: https://wiki.nixos.org/wiki/Git
  */


  programs.git = {

    enable = true;


    settings = {
      user = {
        name = "Zain Eris Kamal";
        email = "zain.eris.kamal@rutgers.edu";
      };
      init.defaultBranch = "main";
      core.editor = "zeditor --wait --new";
    };

    /* sign commits with SSH by default */
    signing = {
      signByDefault = true;  # "Whether commits and tags should be signed by default."
      format = "ssh";
      key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
    };

  };



  /* According to nixos wiki, the above config for signing commits requires home-manager to manage your SSH config. */
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*".addKeysToAgent = "yes";
  };

  /* Automatically start SSH agent for my user, so I don't have to type the passphrase every commit. */
  services.ssh-agent = {
    enable = true;
  };

}
