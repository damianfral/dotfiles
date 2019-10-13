{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      abduco
      atool
      cloc
      curl
      git-hub
      gnumake
      haskellPackages.wai-app-static
      haskellPackages.xmobar
      htop
      httpie
      maim # Takes screenshots
      mosh
      ncdu # NCurses Disk Usage
      nix
      nodejs
      tig
      trash-cli
      up
      vis
      wget
      yarn
      kubernetes
    ];

  programs.alacritty.enable   = true;
  programs.alacritty.settings = {
    env.TERM          = "xterm-256color";
    window.dimensions.columns = 80;
    window.dimensions.lines   = 24;

    dpi = { x = 96; y     = 96; };
    font.size = 10;
    tabspaces = 2;
    draw_bold_text_witj_bright_colors = true;
    # Colors (Gotham)
    colors   = {
      # Default colors
      primary = {
        background = "0x0a0f14";
        foreground = "0x98d1ce";
      };

      # Normal colors
      normal = {
        black   = "0x0a0f14";
        red     = "0xc33027";
        green   = "0x26a98b";
        yellow  = "0xedb54b";
        blue    = "0x195465";
        magenta = "0x4e5165";
        cyan    = "0x33859d";
        white   = "0x98d1ce";
      };

      # Bright colors
      bright = {
        black   = "0x10151b";
        red     = "0xd26939";
        green   = "0x48af7d";
        yellow  = "0x245361";
        blue    = "0x396788";
        magenta = "0x888ba5";
        cyan    = "0x599caa";
        white   = "0xd3ebe9";
      };
    };

    mouse.hide_when_typing = true;
    live_config_reload     = true;
  };

  programs.fish.enable       = true;
  programs.fish.shellAliases = {
    today = "date '+%Y/%m/%d'";
  };
    
  programs.starship.enable   = true;

  programs.broot.enable = true;

  programs.firefox.enable    = true;
  programs.mpv.enable        = true;
  programs.obs-studio.enable = true;

  programs.git.enable        = true;
  programs.git.userName      = "damianfral";
  programs.git.userEmail     = "huevofritopamojarpan@gmail.com";

  programs.gpg.enable = true;
  programs.home-manager.enable = true;

  programs.neovim.enable       = true;
  programs.neovim.withPython   = true;
  programs.neovim.withPython3  = true;
  programs.neovim.withNodeJs   = true;
  programs.neovim.viAlias      = true;
  programs.neovim.vimAlias     = true;
  programs.neovim.extraConfig  = builtins.readFile ./init.vim;

  programs.ssh.enable         = true;
  programs.ssh.compression    = true;
  programs.ssh.controlMaster  = "auto";
  programs.ssh.controlPersist = "1h";
  programs.ssh.extraConfig    = ''
    BatchMode no
    AddKeysToAgent yes
    ForwardAgent yes
    ServerAliveInterval 60
    ServerAliveCountMax 10
    EscapeChar none
    IdentitiesOnly yes
  '';
  programs.ssh.matchBlocks = import ./ssh-hosts.nix;

  xdg.enable        = true;

  services.gpg-agent.enable = true;
  services.gpg-agent.enableScDaemon = true;
  services.gpg-agent.enableSshSupport = true;
  services.gpg-agent.defaultCacheTtl = 3600;
  

  # RedShift
  services.redshift.enable            = true;
  services.redshift.latitude          = "42.28185";
  services.redshift.longitude         = "-8.60917";
  services.redshift.brightness.day    = "1";
  services.redshift.temperature.day   = 6500;
  services.redshift.brightness.night  = "0.8";
  services.redshift.temperature.night = 5500;

  services.keybase.enable = true;
  services.kbfs.enable = true;

  services.xsuspender.enable          = true;
  services.dunst.enable = true;
  services.dunst.settings = {
    global = {

      font               = "Anonymous Pro 11";
      allow_markup       = true;
      plain_text         = false;
      format             = "<b>%s</b>\\n%b";
      stack_duplicates   = true;
      geometry           = "300x50-15+49";
      follow             = "mouse";
      separator_height   = 2;
      padding            = 6;
      horizontal_padding = 6;
      separator_color    = "frame";

    }; 

    shortcuts = {
      close = "ctrl+space";

      close_all = "ctrl+shift+space";

      # Redisplay last message(s).
      # On the US keyboard layout "grave" is normally above TAB and left
      # of "1".
      history = "ctrl+grave";

      # Context menu.
      context = "ctrl+shift+period";

    };

    frame = {

      width = 3;
      color = "#002B36";
    };

    urgency_low = {
      frame_color = "#3B7C87";
      foreground = "#3B7C87";
      background = "#0A0F14";
      timeout = 4;
    };

    urgency_normal = {
      frame_color = "#5B8234";
      foreground = "#5B8234";
      background = "#0A0F14";
      timeout = 6;
    };

    urgency_critical = {
      frame_color = "#B7472A";
      foreground = "#B7472A";
      background = "#0A0F14";
      timeout = 8;
    };
  };

  xsession.enable = true;
  xsession.windowManager.xmonad.enable                 = true;
  xsession.windowManager.xmonad.enableContribAndExtras = true;
  xsession.windowManager.xmonad.config = /home/damianfral/devel/dotfiles/xmonad.hs;

  home.file.xmobar = {
    source = ./xmobarrc;
    target = ".xmobarrc";
  };

  home.file.neovim = {
    source = ./init.vim;
    target = ".config/nvim/init.vim";
  };

  home.sessionVariables = {
    DSSI_PATH   = "$HOME/.dssi:$HOME/.nix-profile/lib/dssi:/run/current-system/sw/lib/dssi";
    LADSPA_PATH = "$HOME/.ladspa:$HOME/.nix-profile/lib/ladspa:/run/current-system/sw/lib/ladspa";
    LV2_PATH    = "$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";
    LXVST_PATH  = "$HOME/.lxvst:$HOME/.nix-profile/lib/lxvst:/run/current-system/sw/lib/lxvst";
    VST_PATH    = "$HOME/.vst:$HOME/.nix-profile/lib/vst:/run/current-system/sw/lib/vst";
};

}
