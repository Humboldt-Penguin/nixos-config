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
      jdk
      eclipses.eclipse-jee
    ]);

}
