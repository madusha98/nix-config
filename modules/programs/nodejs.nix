{ pkgs, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    nodejs_22
    pnpm
    yarn
  ];

  home-manager.users.${vars.user} = {
    home.packages = with pkgs; [
      nodejs_22
      pnpm
      yarn
    ];
  };
}