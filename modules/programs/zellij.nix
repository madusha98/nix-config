{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    programs = {
      zellij = {
        enable = true;
      };
    };
  };
}