{ config, pkgs, ... }:

{

  services = {
    mysql = {
      enable = true;
      package = pkgs.mysql80;
    };
    tomcat = {
      enable = true;
      package = pkgs.tomcat9;
    };
  };


  environment.systemPackages =
    (with pkgs; [
      mysql-workbench
      mysql-shell   ## part of mysql windows installer tbf
      mysql_jdbc    ## not sure if this is the correct way to load it...?
      jdk
      eclipses.eclipse-jee
    ]);

}
