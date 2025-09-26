{
  lib,
  config,
  pkgs,
  stable,
  inputs,
  vars,
  ...
}:

let
  terminal = pkgs.${vars.terminal};
in
{
  imports = (
    import ../modules/desktops
    ++ import ../modules/editors
    ++ import ../modules/hardware
    ++ import ../modules/programs
    ++ import ../modules/services
    ++ import ../modules/theming
    ++ import ../modules/shell
  );

  boot = {
    tmp = {
      cleanOnBoot = true;
      tmpfsSize = "5GB";
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  users.users.${vars.user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "camera"
      "networkmanager"
      "lp"
      "scanner"
    ];
  };

  time.timeZone = "Asia/Colombo";

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.wheelNeedsPassword = true;
  };

  networking.networkmanager.enable = true;

  fonts.packages = with pkgs; [
    carlito # NixOS
    vegur # NixOS
    source-code-pro
    jetbrains-mono
    font-awesome # Icons
    corefonts # MS
    noto-fonts # Google + Unicode
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.space-mono
  ];

  environment = {
    variables = {
      TERMINAL = "${vars.terminal}";
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
      SSH_AUTH_SOCK = "/home/${vars.user}/.bitwarden-ssh-agent.sock";
    };
    systemPackages =
      with pkgs;
      [
        # Terminal
        terminal # Terminal Emulator
        btop # Resource Manager
        cifs-utils # Samba
        coreutils # GNU Utilities
        git # Version Control
        killall # Process Killer
        lshw # Hardware Config
        nano # Text Editor

        nix-tree # Browse Nix Store
        pciutils # Manage PCI
        ranger # File Manager
        tldr # Helper
        usbutils # Manage USB
        wget # Retriever
        xdg-utils # Environment integration
        vim # VIM

        # Video/Audio
        alsa-utils # Audio Control
        feh # Image Viewer
        linux-firmware # Proprietary Hardware Blob
        mpv # Media Player
        pavucontrol # Audio Control
        pipewire # Audio Server/Control
        qpwgraph # Pipewire Graph Manager

        # Apps
        appimage-run # Runs AppImages on NixOS
        remmina # XRDP & VNC Client

        # File Management
        file-roller # Archive Manager
        xfce.thunar # File Browser
        p7zip # Zip Encryption
        rsync # Syncer - $ rsync -r dir1/ dir2/
        unzip # Zip Files
        unrar # Rar Files
        zip # Zip

        dmenu # dmenu

        gnupg # pgp
        gnumake
        ripgrep # rip grep

        xclip # access the X clipboard from console
        fzf # fuzzy find

        flameshot # screenshot utils
        networkmanagerapplet # network manager applet

        dbgate # database management
        pgadmin4-desktopmode # postgresql management

        awscli2 # aws cli
        kubectl # kubernets cli

        dig # domain name server

        # Other Packages Found @
        # - ./<host>/default.nix
        # - ../modules
        nmap
        ansible
        terraform
        fluxcd
        cmake
        clang
        libtool
        hurl

        # vpn stuff
        openvpn

        vscode
        claude-code

        nixfmt-rfc-style
      ]
      ++ (with stable; [
        # Apps
        # firefox # Browser
        image-roll # Image Viewer
        qutebrowser # yes
        postman

        # android mtp support
        mtpfs
        jmtpfs
      ]);
  };

  programs = {
    dconf.enable = true;
    nix-ld = {
      enable = true;
      libraries = [ ];
    };
    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
  };

  hardware.enableAllFirmware = true;

  services = {
    printing = {
      enable = false;
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.extraConfig."11-bluetooth-policy" = {
        "wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = false;
        };
      };
    };
    openssh = {
      enable = true;
      allowSFTP = true;
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      '';
    };
  };

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    # package = pkgs.nixVersions.latest;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true;

  system = {
    # autoUpgrade = {
    #   enable = true;
    #   channel = "https://nixos.org/channels/nixos-unstable";
    # };
    stateVersion = vars.stateVersion;
  };

  home-manager.users.${vars.user} = {
    home = {
      stateVersion = vars.stateVersion;
    };
    programs = {
      home-manager.enable = true;
    };

    xdg = {
      mime.enable = true;
      mimeApps = lib.mkIf (config.gnome.enable == false) {
        enable = true;
        defaultApplications = {
          "image/jpeg" = [
            "image-roll.desktop"
            "feh.desktop"
          ];
          "image/png" = [
            "image-roll.desktop"
            "feh.desktop"
          ];
          "text/plain" = "nvim.desktop";
          "text/html" = "nvim.desktop";
          "text/csv" = "nvim.desktop";
          "application/pdf" = [
            "firefox.desktop"
            "google-chrome.desktop"
          ];
          "application/zip" = "org.gnome.FileRoller.desktop";
          "application/x-tar" = "org.gnome.FileRoller.desktop";
          "application/x-bzip2" = "org.gnome.FileRoller.desktop";
          "application/x-gzip" = "org.gnome.FileRoller.desktop";
          "x-scheme-handler/http" = [
            "firefox.desktop"
            "google-chrome.desktop"
          ];
          "x-scheme-handler/https" = [
            "firefox.desktop"
            "google-chrome.desktop"
          ];
          "x-scheme-handler/about" = [
            "firefox.desktop"
            "google-chrome.desktop"
          ];
          "x-scheme-handler/unknown" = [
            "firefox.desktop"
            "google-chrome.desktop"
          ];
          "x-scheme-handler/mailto" = [ "gmail.desktop" ];
          "audio/mp3" = "mpv.desktop";
          "audio/x-matroska" = "mpv.desktop";
          "video/webm" = "mpv.desktop";
          "video/mp4" = "mpv.desktop";
          "video/x-matroska" = "mpv.desktop";
          "inode/directory" = "pcmanfm.desktop";
        };
      };
      desktopEntries.image-roll = {
        name = "image-roll";
        exec = "${stable.image-roll}/bin/image-roll %F";
        mimeType = [ "image/*" ];
      };
    };
  };
}
