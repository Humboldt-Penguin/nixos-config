{
  config,
  pkgs,
  ...
}:

{

  /* Enable zsh (following these instructions: https://nixos.wiki/wiki/Command_Shell) */
  programs.zsh.enable = true;          # > "When adding a new shell, always enable the shell system-wide, even if it's already enabled in your Home Manager configuration, otherwise it won't source the necessary files."
  # users.defaultUserShell = pkgs.zsh;   # Enable globally
  users.users.lain.shell = pkgs.zsh;   # Enable for my own user

}
