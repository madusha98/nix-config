{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    programs = {
      lazygit = {
        enable = true;
      };
    };
  };
}