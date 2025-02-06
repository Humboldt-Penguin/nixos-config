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

  programs = {
    git = {

      enable = true;
      package = pkgs.git;

      userName  = "Zain Eris Kamal";
      userEmail = "zain.eris.kamal@rutgers.edu";

      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        core = {
          # editor = "codium --wait --new-window";  ## slow bleh
          # editor = "micro";  ## fast, but minor pasting annoyances, plus you lose access/sight of terminal
          editor = "zeditor --wait --new";
        };
      };

    };
  };

}
