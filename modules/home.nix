{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ./nixvim.nix ];

  home.stateVersion = "25.11";
  home.homeDirectory = "/Users/trevato";

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      extended = true;
      share = true;
    };

    shellAliases = {
      # Git
      g = "git";
      gs = "git status";
      gd = "git diff";
      gds = "git diff --staged";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gco = "git checkout";
      gcb = "git checkout -b";
      glog = "git log --oneline --graph --decorate -20";

      # Nix
      nrs = "nix flake update nixpkgs --flake ~/dotfiles && sudo darwin-rebuild switch --flake ~/dotfiles";
      nfu = "nix flake update";

      # Docker
      d = "docker";
      dc = "docker compose";
      dps = "docker ps";
      lzd = "lazydocker";

      # Kubernetes
      k = "kubectl";
      kgp = "kubectl get pods";
      kgs = "kubectl get svc";
      kga = "kubectl get all";
      kns = "kubectl config set-context --current --namespace";
      h = "helm";
      ks = "kustomize";
      lzk = "k9s";

      # Quick
      v = "nvim";
      lg = "lazygit";
      ".." = "cd ..";
      "..." = "cd ../..";
    };

    initContent = ''
      unset OTEL_EXPORTER_OTLP_METRICS_TEMPORALITY_PREFERENCE
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward
    '';
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "/Users/trevato/.colima/ssh_config" ];
    matchBlocks = {
      "vxrail" = {
        host = "vxrail otavert-vxrail 10.0.0.44";
        hostname = "otavert-vxrail";
        user = "trevato";
        identityFile = "~/.ssh/vxrail";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # Caches devShells for instant activation
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$kubernetes$nix_shell$cmd_duration$character";

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      nix_shell = {
        heuristic = true;
        symbol = "❄️ ";
        style = "bold blue";
        format = "[$symbol]($style) ";
      };

      kubernetes = {
        disabled = false;
        symbol = "⎈ ";
        style = "bold blue";
        format = "[$symbol$context( \\($namespace\\))]($style) ";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = false;
        style = "bold cyan";
      };
    };
  };

  programs.ghostty = {
    enable = true;
    package = null;
    enableZshIntegration = true;
    settings = {
      font-family = "FiraCode Nerd Font Mono";
      font-size = 14;
      background-opacity = 0.7;
      mouse-hide-while-typing = true;
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--border"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };

  programs.bat = {
    enable = true;
    config.theme = "Catppuccin Mocha";
  };

  programs.fd.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "trevato";
      user.email = "me@trevato.dev";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rebase.autoStash = true;
      merge.conflictstyle = "zdiff3";
      diff.algorithm = "histogram";
      rerere.enabled = true;
      fetch.prune = true;
      alias = {
        st = "status -sb";
        amend = "commit --amend --no-edit";
        undo = "reset --soft HEAD~1";
      };
    };
    includes = [
      {
        condition = "gitdir:~/projects/inception/";
        contents = {
          user.name = "Trevor Dobbertin";
          user.email = "tdobbertin@inceptionllc.com";
        };
      }
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
    };
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.btop = {
    enable = true;
    settings = {
      force_tty = true; # Transparent background
      vim_keys = true;
      theme_background = false;
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git.pagers = [
        {
          command = "diff";
          pager = "delta --dark --paging=never";
        }
        {
          command = "show";
          pager = "delta --dark --paging=never";
        }
      ];
    };
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      search_mode = "fuzzy";
      filter_mode = "global";
      style = "compact";
      inline_height = 20;
      show_preview = true;
    };
  };

  programs.zellij = {
    enable = true;
    settings = {
      theme = "catppuccin-mocha";
      default_layout = "compact";
      pane_frames = false;
    };
  };

  home.sessionVariables.K9S_CONFIG_DIR = "$HOME/.config/k9s";

  home.file.".config/k9s/config.yaml".text = builtins.toJSON {
    k9s = {
      liveViewAutoRefresh = false;
      refreshRate = 2;
      ui = {
        enableMouse = false;
        headless = false;
        logoless = false;
        crumbsless = false;
        noIcons = false;
        skin = "catppuccin-mocha-transparent";
      };
    };
  };

  home.file.".config/k9s/skins/catppuccin-mocha-transparent.yaml".text = builtins.toJSON {
    k9s = {
      body = {
        fgColor = "#cdd6f4";
        bgColor = "default";
        logoColor = "#cba6f7";
      };
      prompt = {
        fgColor = "#cdd6f4";
        bgColor = "default";
        suggestColor = "#89b4fa";
      };
      help = {
        fgColor = "#cdd6f4";
        bgColor = "default";
        sectionColor = "#a6e3a1";
        keyColor = "#89b4fa";
        numKeyColor = "#eba0ac";
      };
      frame = {
        title = {
          fgColor = "#94e2d5";
          bgColor = "default";
          highlightColor = "#f5c2e7";
          counterColor = "#f9e2af";
          filterColor = "#a6e3a1";
        };
        border = {
          fgColor = "#cba6f7";
          focusColor = "#b4befe";
        };
        menu = {
          fgColor = "#cdd6f4";
          keyColor = "#89b4fa";
          numKeyColor = "#eba0ac";
        };
        crumbs = {
          fgColor = "#1e1e2e";
          bgColor = "default";
          activeColor = "#f2cdcd";
        };
        status = {
          newColor = "#89b4fa";
          modifyColor = "#b4befe";
          addColor = "#a6e3a1";
          pendingColor = "#fab387";
          errorColor = "#f38ba8";
          highlightColor = "#89dceb";
          killColor = "#cba6f7";
          completedColor = "#6c7086";
        };
      };
      info = {
        fgColor = "#fab387";
        sectionColor = "#cdd6f4";
      };
      views = {
        table = {
          fgColor = "#cdd6f4";
          bgColor = "default";
          cursorFgColor = "#313244";
          cursorBgColor = "#45475a";
          markColor = "#f5e0dc";
          header = {
            fgColor = "#f9e2af";
            bgColor = "default";
            sorterColor = "#89dceb";
          };
        };
        xray = {
          fgColor = "#cdd6f4";
          bgColor = "default";
          cursorColor = "#45475a";
          cursorTextColor = "#1e1e2e";
          graphicColor = "#f5c2e7";
        };
        charts = {
          bgColor = "default";
          chartBgColor = "default";
          dialBgColor = "default";
          defaultDialColors = [
            "#a6e3a1"
            "#f38ba8"
          ];
          defaultChartColors = [
            "#a6e3a1"
            "#f38ba8"
          ];
          resourceColors = {
            cpu = [
              "#cba6f7"
              "#89b4fa"
            ];
            mem = [
              "#f9e2af"
              "#fab387"
            ];
          };
        };
        yaml = {
          keyColor = "#89b4fa";
          valueColor = "#cdd6f4";
          colonColor = "#a6adc8";
        };
        logs = {
          fgColor = "#cdd6f4";
          bgColor = "default";
          indicator = {
            fgColor = "#b4befe";
            bgColor = "default";
            toggleOnColor = "#a6e3a1";
            toggleOffColor = "#a6adc8";
          };
        };
      };
      dialog = {
        fgColor = "#f9e2af";
        bgColor = "default";
        buttonFgColor = "#1e1e2e";
        buttonBgColor = "default";
        buttonFocusFgColor = "#1e1e2e";
        buttonFocusBgColor = "#f5c2e7";
        labelFgColor = "#f5e0dc";
        fieldFgColor = "#cdd6f4";
      };
    };
  };

  home.file.".claude" = {
    source = inputs.claude-config;
    recursive = true;
  };
}
