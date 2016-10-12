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

  security.sudo.enable = true;
  
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
      atool # Work with compressed files
      cloc
      curl
      darcs
      fish
      git
      gitAndTools.gitflow
      gitAndTools.hub
      gnumake
      haskellPackages.cabal2nix
      haskellPackages.wai-app-static
      haskellPackages.xmobar
      htop
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

  programs.mosh.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.transmission.enable = true;
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
}
