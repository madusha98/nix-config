{
  pkgs,
  lib,
  vars,
  ...
}:

{
  home-manager.users.${vars.user} = {
    programs.chromium = {
      enable = true;
    };
  };

  
}