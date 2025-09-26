{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

with lib;
{
  options = {
    i3 = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf (config.i3.enable) {
    # Enable X11 and window manager
    services.xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
      };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3status
          i3lock
          i3blocks
        ];
      };
      displayManager = {
        defaultSession = "none+i3";
        lightdm = {
          enable = true;
          greeters.slick = {
            enable = true;
            theme.name = "Arc-Dark";
          };
        };
      };
    };

    # Audio support
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Input configuration
    services.libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        accelSpeed = "0.5";
        tapping = true;
      };
    };

    # System packages for i3 (EndeavourOS-style)
    environment.systemPackages = with pkgs; [
      # Window manager essentials
      i3
      i3status
      i3lock
      i3blocks
      dmenu
      rofi
      picom
      feh
      arandr
      
      # EndeavourOS-style tools
      xfce.thunar
      xfce.thunar-volman
      gvfs
      xfce.tumbler
      
      # System tools
      pavucontrol
      networkmanagerapplet
      blueman
      xorg.xbacklight
      brightnessctl
      playerctl
      polkit_gnome
      
      # Terminal and utilities
      alacritty
      firefox
      code-server
      
      # Appearance
      lxappearance
      arc-theme
      arc-icon-theme
      papirus-icon-theme
      
      # Screenshots
      scrot
      maim
      imagemagick
      
      # System info
      neofetch
      htop
      
      # Notifications
      dunst
    ];

    # Home Manager configuration for i3
    home-manager.users.${vars.user} = {
      xsession.windowManager.i3 = {
        enable = true;
        config = {
          modifier = "Mod4"; # Super key
          terminal = "alacritty";
          
          # Let Stylix handle fonts and colors
          gaps = {
            inner = 5;
            outer = 2;
            smartGaps = true;
            smartBorders = "on";
          };

          keybindings = lib.mkOptionDefault {
            "Mod4+Return" = "exec alacritty";
            "Mod4+d" = "exec rofi -show drun";
            "Mod4+Shift+d" = "exec dmenu_run";
            "Mod4+l" = "exec --no-startup-id ~/.config/i3/scripts/blur-lock";
            "Mod4+Shift+x" = "exec i3lock -c 000000";
            "Mod4+Shift+e" = "exec ~/.config/i3/scripts/powermenu.sh";
            
            # Screenshots
            "Print" = "exec scrot ~/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png";
            "Shift+Print" = "exec scrot -s ~/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png";
            
            # Audio controls
            "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
            
            # Media controls
            "XF86AudioPlay" = "exec playerctl play-pause";
            "XF86AudioNext" = "exec playerctl next";
            "XF86AudioPrev" = "exec playerctl previous";
            
            # Brightness controls
            "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
            "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
          };

          bars = [{
            position = "top";
            statusCommand = "i3blocks";
            # Let Stylix handle bar colors
          }];

          startup = [
            { command = "picom -b"; always = true; notification = false; }
            { command = "feh --bg-scale ~/.wallpaper"; always = true; notification = false; }
            { command = "nm-applet"; always = true; notification = false; }
            { command = "blueman-applet"; always = true; notification = false; }
            { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; always = true; notification = false; }
          ];
        };
      };

      # i3blocks configuration
      home.file.".config/i3/i3blocks.conf".source = ./i3blocks.conf;

      # Create Pictures/Screenshots directory
      home.file."Pictures/Screenshots/.keep".text = "";
      
      
      # Copy blur-lock script
      home.file.".config/i3/scripts/blur-lock" = {
        source = ./scripts/blur-lock;
        executable = true;
      };
      
      # Copy power menu script
      home.file.".config/i3/scripts/powermenu.sh" = {
        source = ./scripts/powermenu.sh;
        executable = true;
      };
      
      # Picom configuration
      # services.picom = {
      #   enable = true;
      #   fade = true;
      #   fadeSteps = [ 0.03 0.03 ];
      #   shadow = true;
      #   shadowOffsets = [ (-7) (-7) ];
      #   shadowOpacity = 0.7;
      #   activeOpacity = 1.0;
      #   inactiveOpacity = 0.95;
      #   backend = "glx";
      #   vSync = true;
      #   settings = {
      #     shadow-radius = 7;
      #     corner-radius = 8;
      #   };
      # };

      # Dunst is already configured in modules/services/dunst.nix
      
      # Configure rofi with Stylix theming
      programs.rofi = {
        enable = true;
        extraConfig = {
          display-drun = "Applications";
          display-window = "Windows";
          show-icons = true;
          icon-theme = "Papirus";
        };
      };
    };

    # Enable fonts
    fonts.packages = with pkgs; [
      dejavu_fonts
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
    ];
  };
}