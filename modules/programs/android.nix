{ pkgs, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    android-studio
    android-tools
    jdk17
  ];
  
  environment.variables = {
    ANDROID_HOME = "/home/${vars.user}/Android/Sdk";
    ANDROID_SDK_ROOT = "/home/${vars.user}/Android/Sdk";
  };
}