# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable  = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device  = "/dev/sda";

  networking.hostName              = "nixos"; # Define your hostname.
  networking.wireless.enable       = false;
  networking.networkmanager.enable = true;
  
  networking.firewall.allowedTCPPorts = [22 3000 3030 3333 5000 8000 8080 8888 9000 ];
  networking.firewall.allowPing       = true;

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
  powerManagement.resumeCommands = "dm-tool lock";

  security.sudo.enable = true;
  
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
      atool # Work with compressed files
      cloc
      curl
      cmus  # Console music player
      darcs
      dunst
      fish
      git
      gitAndTools.gitflow
      gitAndTools.hub
      gnumake
      haskellPackages.cabal2nix
      haskellPackages.wai-app-static
      haskellPackages.xmobar
      htop
      maim # Takes screenshots
      mosh
      ncdu # NCurses Disk Usage
      neovim
      nix
      nix-repl
      profanity
      termite
      trash-cli
      wget
      xdg_utils
  ];
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;


  # Enable the X11 windowing system.
  services.xserver.enable     = true;
  services.xserver.layout     = "us";
  services.xserver.xkbOptions = "eurosign:e";

  # Xmonad
  services.xserver.windowManager.xmonad.enable                 = true;     # installs xmonad and makes it available
  services.xserver.windowManager.xmonad.enableContribAndExtras = true; # makes xmonad-contrib and xmonad-extras available
  services.xserver.windowManager.default                       = "xmonad"; # sets it as default
  services.xserver.desktopManager.default                      = "none";   # the plain xmonad experience

  # LightDM
  services.xserver.displayManager.lightdm.enable = true;
  # GPU support
  hardware.opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
  services.xserver.useGlamor = true;
  # Laptop
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

  services.teamviewer.enable = true;

  services.nixosManual.showManual = true;

  zramSwap.enable         = true;
  time.timeZone           = "Europe/Madrid";
  services.devmon.enable = true;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.damianfral = {
      description     = "damianfral";
      isNormalUser    = true;
      uid             = 1000;
      initialPassword = "1234";
      createHome = true;
  };

  users.defaultUserShell  = "${pkgs.fish}/bin/fish";
  nix.trustedBinaryCaches = [ "http://hydra.nixos.org" "http://hydra.cryp.to" "https://ryantrinkle.com:5443" ];
}
