# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./yubikey.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModprobeConfig = "options nvidia-drm modeset=1";
  boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];
  boot.initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/nvme0n1p2";
      preLVM = true;
    }
  ];

  networking.hostName              = "nixos"; # Define your hostname.
  networking.wireless.enable       = false;
  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPorts = [22 3000 3030 3333 5000 5300 8000 8081 8080 8888 9000 19000 19001 19002 ];
  networking.firewall.allowPing       = true;

  networking.wireguard.interfaces = {
    wg0 = {
      ips        = [ "10.0.0.2/32" ];
      privateKey = "KBmUJ6iBDtHqnlEWAsltKtjuYzmKJAlhX7l5UOL5B1I=";

      peers = [ {
        publicKey           = "Dqp2QMuAkRuOWgjIE6iGl80/SbYKk2PjBbAi2IsFIUQ=";
        endpoint            = "vpn.damianfral.name:55555";
        allowedIPs          = [ "0.0.0.0/0" ];
        persistentKeepalive = 25;
      }];
    };
  };

  hardware.u2f.enable = true;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  hardware.bumblebee.connectDisplay = true;
  hardware.bumblebee.enable = true;
  hardware.bumblebee.group = "video";
  hardware.bumblebee.pmMethod = "bbswitch";


  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "${pkgs.terminus_font}/share/consolefonts/ter-i16n.psf.gz";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  #};


  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    chromium = {
      enablePepperFlash = true;
      enablePepperPDF   = true;
      enableGoogleTalkPlugin = true;
      enableAdobeFlash       = true;
    };
  };

  fonts = {
     enableFontDir          = true;
     enableGhostscriptFonts = true;
     fonts                  = with pkgs; [
       anonymousPro
       terminus_font
       inconsolata  # monospaced
       ubuntu_font_family  # Ubuntu fonts
     ];
  };

  powerManagement.enable = true;

  security.sudo.enable = true;

  sound.enable = true;
  sound.mediaKeys.enable = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
      alacritty
      atool # Work with compressed files
      cloc
      curl
      dunst
      fish
      git
      gitAndTools.hub
      gnumake
      haskellPackages.wai-app-static
      haskellPackages.xmobar
      htop
      maim # Takes screenshots
      mosh
      ncdu # NCurses Disk Usage
      neovim
      nix
      trash-cli
      wget
      xdg_utils
  ];
  # List services that you want to enable:

  programs.fish.enable = true;
  programs.ssh.startAgent = true;

  services.udev.packages = [ pkgs.rtl-sdr ];
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.keybase.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable     = true;
  services.xserver.layout     = "us";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.screenSection =
    ''
      Identifier "Default Screen"
      Device "DiscreteNvidia"
    '';
  services.xserver.videoDrivers = [ "nvidiaBeta intel" ];

  services.physlock.enable = true;
  services.physlock.lockOn.extraTargets = [ "display-manager.service" ];


  # Xmonad
  services.xserver.windowManager.xmonad.enable                 = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;
  services.xserver.windowManager.default                       = "xmonad";
  services.xserver.desktopManager.default                      = "none";



  # LightDM
  services.xserver.displayManager.lightdm.enable = true;

  # GPU support
  hardware.opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
  services.xserver.useGlamor = true;

  # Touchpad
  services.xserver.synaptics.enable           = true;
  services.xserver.synaptics.horizontalScroll = true;
  services.xserver.synaptics.tapButtons       = true;
  services.xserver.synaptics.twoFingerScroll  = true;

  # RedShift
  services.redshift.enable            = true;
  services.redshift.latitude          = "42.28185";
  services.redshift.longitude         = "-8.60917";
  services.redshift.brightness.day    = "1";
  services.redshift.temperature.day   = 6500;
  services.redshift.brightness.night  = "0.8";
  services.redshift.temperature.night = 5500;

  services.udisks2.enable = true;
  services.devmon.enable = true;

  services.nixosManual.showManual = true;

  virtualisation.docker.enable = true;

  zramSwap.enable         = true;
  time.timeZone           = "Europe/Madrid";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.damianfral = {
      description     = "damianfral";
      isNormalUser    = true;
      uid             = 1000;
      initialPassword = "1234";
      createHome = true;
      extraGroups = [ "wheel" "docker" "networkmanager" "audio" "video" "storage" "lp" ];
  };

  users.defaultUserShell  = "${pkgs.fish}/bin/fish";
  environment.variables = {
    DSSI_PATH   = "$HOME/.dssi:$HOME/.nix-profile/lib/dssi:/run/current-system/sw/lib/dssi";
    LADSPA_PATH = "$HOME/.ladspa:$HOME/.nix-profile/lib/ladspa:/run/current-system/sw/lib/ladspa";
    LV2_PATH    = "$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";
    LXVST_PATH  = "$HOME/.lxvst:$HOME/.nix-profile/lib/lxvst:/run/current-system/sw/lib/lxvst";
    VST_PATH    = "$HOME/.vst:$HOME/.nix-profile/lib/vst:/run/current-system/sw/lib/vst";
};

  nix.useSandbox = true;
  nix.allowedUsers = [ "@wheel" ];
  nix.binaryCaches = [
    "https://cache.nixos.org/"
    "http://vultr.damianfral.name:5000"
    "https://feeld-nixcache.s3.amazonaws.com/"
    "https://cache.nixos.org/"
  ];

  nix.binaryCachePublicKeys = [
    "alberto-valverde-1:A+NbXRfx+Uo0tQNZ8hlip+1zru2P32l7/skPDeaZnxU="
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "vultr.damianfral.name-1:bG+TNRrMdEDvnhgvf2ZH+oDNZ/gTOlsDOsirgg7A3MA="
  ];

  nix.extraOptions =
    ''
      narinfo-cache-negative-ttl = 60
    '';

}
