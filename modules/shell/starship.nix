{ pkgs, vars, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      format = "$all$character";
      
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      directory = {
        truncation_length = 3;
        fish_style_pwd_dir_length = 1;
      };

      package = {
        disabled = true;
      };
    };
  };
}