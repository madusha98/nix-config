{ pkgs, vars, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      clp = "xclip -selection clipboard";
    };
  };

  users.users.${vars.user} = {
    shell = pkgs.fish;
  };
}