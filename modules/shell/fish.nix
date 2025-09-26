{ pkgs, vars, ... }:
{
  programs.fish = {
    enable = true;
  };

  users.users.${vars.user} = {
    shell = pkgs.fish;
  };
}