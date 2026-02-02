{ config, pkgs, lib, zen-browser, ... }:

{
  imports = [ zen-browser.homeModules.beta ];

  home.username = "oskar1233";
  home.homeDirectory = "/home/oskar1233";
  home.stateVersion = "24.11";

  # Let home-manager manage iself
  programs.home-manager.enable = true;

  # Zen browser
  programs.zen-browser.enable = true;

  # direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # zsh
  programs.zsh = {
    enable = true;

    plugins = [
      # zsh-vi-mode - better vim mode in zsh
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];

    oh-my-zsh = {
      enable = true;
      theme = "3den";
      plugins = [
        "git"
        "direnv"
      ];
    };
  };

  # Packages
  home.packages = with pkgs; [
    # Wayland / Niri utilities
    foot              # terminal
    fuzzel            # launcher
    waybar            # status bar
    mako              # notifications
    wl-clipboard      # clipboard
    grim              # screenshots
    slurp             # region selection
    brightnessctl
    playerctl
    
    # Development
    gcc
    gnumake
    
    # CLI tools
    eza               # better ls
    bat               # better cat
    fzf
    fff
    jq
    lazygit
    tmux

    # Other
    zen-browser
  ];

  # Neovim - using config directory approach
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPerl = true;
    withPython3 = true;
    withRuby = true;
    extraConfig = ":luafile ~/.config/nvim/init.lua";
  };

  # Empty neovim config directory - add your config here
  # Structure: ~/.config/nvim/init.lua or ~/.config/nvim/lua/...
  xdg.configFile."nvim/.keep".text = "";

  # xdg.configFile."nvim/init.lua" = {
  #   source = ../nvim/init.lua;
  #   # recursive = true;
  # };
  # xdg.configFile."nvim/init.lua" = {
  #   source = ./nvim/init.lua;
  #   recursive = true;
  # };

  # Niri configuration
  programs.niri.settings = {
    input = {
      keyboard.xkb = {
        layout = "pl";
        # options = "caps:escape";  # Optional: Caps Lock as Escape
      };
      
      mouse = {
        accel-speed = 0.0;
      };
      
      touchpad = {
        tap = true;
        natural-scroll = true;
      };
    };

    outputs = {
      "*" = {
        scale = 1.0;
        # background-color = "#1e1e2e";
      };
    };

    layout = {
      gaps = 8;
      
      border = {
        width = 2;
        active.color = "#89b4fa";
        inactive.color = "#313244";
      };
      
      focus-ring = {
        enable = false;
      };
      
      preset-column-widths = [
        { proportion = 1.0 / 3.0; }
        { proportion = 1.0 / 2.0; }
        { proportion = 2.0 / 3.0; }
      ];
      
      default-column-width = { proportion = 1.0 / 2.0; };
    };

    spawn-at-startup = [
      { command = [ "waybar" ]; }
      { command = [ "mako" ]; }
    ];

    binds = with config.lib.niri.actions; {
      # Applications
      "Mod+Return".action = spawn "foot";
      "Mod+D".action = spawn "fuzzel";
      "Mod+E".action = spawn "foot" "-e" "yazi";  # file manager (install yazi if you want)

      # Window management
      "Mod+Q".action = close-window;
      "Mod+F".action = fullscreen-window;
      "Mod+M".action = maximize-column;

      # Focus
      "Mod+H".action = focus-column-left;
      "Mod+J".action = focus-window-down;
      "Mod+K".action = focus-window-up;
      "Mod+L".action = focus-column-right;
      
      "Mod+Left".action = focus-column-left;
      "Mod+Down".action = focus-window-down;
      "Mod+Up".action = focus-window-up;
      "Mod+Right".action = focus-column-right;

      # Move windows
      "Mod+Shift+H".action = move-column-left;
      "Mod+Shift+J".action = move-window-down;
      "Mod+Shift+K".action = move-window-up;
      "Mod+Shift+L".action = move-column-right;

      "Mod+Shift+Left".action = move-column-left;
      "Mod+Shift+Down".action = move-window-down;
      "Mod+Shift+Up".action = move-window-up;
      "Mod+Shift+Right".action = move-column-right;

      # Workspaces
      "Mod+1".action = focus-workspace 1;
      "Mod+2".action = focus-workspace 2;
      "Mod+3".action = focus-workspace 3;
      "Mod+4".action = focus-workspace 4;
      "Mod+5".action = focus-workspace 5;

      # "Mod+Shift+1".action = move-column-to-workspace 1;
      # "Mod+Shift+2".action = move-column-to-workspace 2;
      # "Mod+Shift+3".action = move-column-to-workspace 3;
      # "Mod+Shift+4".action = move-column-to-workspace 4;
      # "Mod+Shift+5".action = move-column-to-workspace 5;

      # Column sizing
      "Mod+R".action = switch-preset-column-width;
      "Mod+Minus".action = set-column-width "-10%";
      "Mod+Equal".action = set-column-width "+10%";

      # Scrolling
      "Mod+WheelScrollDown" = { 
        action = focus-workspace-down; 
        cooldown-ms = 150; 
      };
      "Mod+WheelScrollUp" = { 
        action = focus-workspace-up; 
        cooldown-ms = 150; 
      };

      # Screenshots
      # "Print".action = screenshot;
      # "Mod+Print".action = screenshot-screen;
      # "Mod+Shift+Print".action = screenshot-window;

      # Media keys
      "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+";
      "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
      "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
      "XF86AudioPlay".action = spawn "playerctl" "play-pause";
      "XF86AudioNext".action = spawn "playerctl" "next";
      "XF86AudioPrev".action = spawn "playerctl" "previous";

      # Brightness
      "XF86MonBrightnessUp".action = spawn "brightnessctl" "set" "5%+";
      "XF86MonBrightnessDown".action = spawn "brightnessctl" "set" "5%-";

      # Session
      "Mod+Shift+E".action = quit;
      "Mod+Shift+Slash".action = show-hotkey-overlay;
    };
  };

  # Foot terminal
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "monospace:size=11";
        pad = "8x8";
      };
      colors = {
        # Catppuccin Mocha - adjust to your preference
        background = "1e1e2e";
        foreground = "cdd6f4";
        regular0 = "45475a";
        regular1 = "f38ba8";
        regular2 = "a6e3a1";
        regular3 = "f9e2af";
        regular4 = "89b4fa";
        regular5 = "f5c2e7";
        regular6 = "94e2d5";
        regular7 = "bac2de";
        bright0 = "585b70";
        bright1 = "f38ba8";
        bright2 = "a6e3a1";
        bright3 = "f9e2af";
        bright4 = "89b4fa";
        bright5 = "f5c2e7";
        bright6 = "94e2d5";
        bright7 = "a6adc8";
      };
    };
  };

  # Fuzzel launcher
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "monospace:size=12";
        terminal = "foot";
        layer = "overlay";
      };
      colors = {
        background = "1e1e2edd";
        text = "cdd6f4ff";
        selection = "585b70ff";
        selection-text = "cdd6f4ff";
        border = "89b4faff";
      };
      border = {
        width = 2;
        radius = 8;
      };
    };
  };

  # Mako notifications
  services.mako = {
    enable = true;
    backgroundColor = "#1e1e2e";
    textColor = "#cdd6f4";
    borderColor = "#89b4fa";
    borderRadius = 8;
    borderSize = 2;
    padding = "12";
    defaultTimeout = 5000;
  };

  # Waybar
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 8;
        
        modules-left = [ "niri/workspaces" "niri/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "battery" "tray" ];

        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "●";
            default = "○";
          };
        };

        "niri/window" = {
          max-length = 50;
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d %H:%M}";
          tooltip-format = "<tt>{calendar}</tt>";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 muted";
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        network = {
          format-wifi = "󰖩 {signalStrength}%";
          format-ethernet = "󰈀 connected";
          format-disconnected = "󰖪 disconnected";
          tooltip-format = "{ifname}: {ipaddr}";
        };

        battery = {
          format = "{icon} {capacity}%";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          format-charging = "󰂄 {capacity}%";
        };

        tray = {
          spacing = 8;
        };
      };
    };
    style = ''
      * {
        font-family: monospace;
        font-size: 13px;
      }

      window#waybar {
        background-color: #1e1e2e;
        color: #cdd6f4;
        border-bottom: 2px solid #313244;
      }

      #workspaces button {
        padding: 0 8px;
        color: #6c7086;
      }

      #workspaces button.active {
        color: #89b4fa;
      }

      #clock, #pulseaudio, #network, #battery, #tray {
        padding: 0 12px;
      }
    '';
  };

  # Git
  programs.git = {
    enable = true;
    userName = "oskar1233";
    userEmail = "me@oskar12333.dev";
  };

  # Bash
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "eza";
      ll = "eza -la";
      cat = "bat";
      g = "git";
      v = "nvim";
    };
  };
}
