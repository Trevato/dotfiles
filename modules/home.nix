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
      nrs = "sudo darwin-rebuild switch --flake ~/dotfiles";
      nfu = "nix flake update";

      # Docker
      d = "docker";
      dc = "docker compose";
      dps = "docker ps";
      lzd = "lazydocker";

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
      format = "$directory$git_branch$git_status$nix_shell$cmd_duration$character";

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

  home.file.".claude" = {
    source = inputs.claude-config;
    recursive = true;
  };
}
