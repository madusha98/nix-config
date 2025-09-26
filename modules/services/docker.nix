{ pkgs, vars, ... }:
{
  
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  users.users.${vars.user}.extraGroups = [ "docker" ];
 
  environment.systemPackages = with pkgs; [
    dive
    docker-compose
  ];
}