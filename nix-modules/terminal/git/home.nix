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


  programs = {

    git = {

      enable = true;
      package = pkgs.git;



      userName  = "Zain Eris Kamal";
      userEmail = "zain.eris.kamal@rutgers.edu";

      /* sign commits with SSH by default */
      signing = {
        signByDefault = true;  # "Whether commits and tags should be signed by default."
        format = "ssh";
        key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      };



      extraConfig = {
        init.defaultBranch = "main";

        # core.editor = "codium --wait --new-window";  ## slow bleh
        # core.editor = "micro";  ## fast, but minor pasting annoyances, plus you lose access/sight of terminal
        core.editor = "zeditor --wait --new";
      };


    };



    /* According to nixos wiki, the above config for signing commits requires home-manager to manage your SSH config. */
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };

  };

}
