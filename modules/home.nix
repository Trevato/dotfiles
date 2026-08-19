# Portable user environment — works on macOS (via nix-darwin) and any Linux
# box (via standalone home-manager). Machine-specific config lives outside the
# repo in ~/.zshrc.local, ~/.gitconfig.local, and ~/.ssh/config.local.
{
  config,
  pkgs,
  lib,
  user,
  ...
}:
let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  imports = [
    ./nixvim.nix
    ./claude.nix
  ];

  home.stateVersion = "25.11";
  home.username = user.username;
  home.homeDirectory = if isDarwin then "/Users/${user.username}" else "/home/${user.username}";

  # Standalone home-manager needs its own CLI for `just switch`; on macOS
  # nix-darwin drives the rebuild.
  programs.home-manager.enable = !isDarwin;

  # Tracking nixpkgs-unstable; home-manager/nixvim version strings lag behind.
  # Silence the cosmetic release-mismatch check.
  home.enableNixpkgsReleaseCheck = false;

  # The generated home-configuration.nix manpage embeds the nixpkgs store
  # path without context (eval warning) and the reference lives online anyway.
  manual.manpages.enable = false;

  # Portable dev toolbox — available on every machine, not just the Mac.
  home.packages = with pkgs; [
    gh
    git-credential-oauth
    curl
    jq
    yq
    ripgrep
    tree
    bun
    nodejs
    uv
    just
    watchexec
    sd
    xh
    tldr
    # Kubernetes — a jumpbox is exactly where these belong
    kubectl
    kubernetes-helm
    helmfile
    kustomize
    k9s
    fluxcd
    supabase-cli
    # Formatters/linters shared by nvim (conform + lsp) and the Claude Code
    # format hook (modules/claude.nix)
    nixfmt
    prettierd
    stylua
    ruff
    eslint_d
  ];

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

      # This repo — recipes live in the justfile; `just` lists them
      nrs = "just --justfile ~/dotfiles/justfile switch";
      nfu = "just --justfile ~/dotfiles/justfile update";

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
      # Async fetch + history-only strategy. Prevents the synchronous buffer
      # redraw on every divergent keystroke that was desyncing the displayed
      # cursor under Ghostty shell integration.
      ZSH_AUTOSUGGEST_USE_ASYNC=1
      ZSH_AUTOSUGGEST_STRATEGY=(history)

      # Prevent Atuin's widget from desyncing the autosuggestion buffer
      ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(atuin-search)

      # Arrows walk history by prefix (atuin keeps Ctrl-R). Both escape forms:
      # zle runs the terminal in application mode, where arrows send ^[O_.
      bindkey '^[[A' history-search-backward
      bindkey '^[OA' history-search-backward
      bindkey '^[[B' history-search-forward
      bindkey '^[OB' history-search-forward

      # Tab title: show working directory at prompt, running command during execution
      autoload -Uz add-zsh-hook
      _set_tab_title() { print -Pn "\e]0;%~\a" }
      _set_cmd_title() { print -Pn "\e]0;$1\a" }
      add-zsh-hook precmd _set_tab_title
      add-zsh-hook preexec _set_cmd_title

      # Appearance detection — macOS reports light/dark; elsewhere default dark
      _APPEARANCE=dark
      if [[ "$OSTYPE" == darwin* ]]; then
        defaults read -g AppleInterfaceStyle &>/dev/null || _APPEARANCE=light
      fi

      # FZF colors (Catppuccin Mocha / Latte)
      if [ "$_APPEARANCE" = "dark" ]; then
        export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
          --color=bg+:#313244,bg:-1,spinner:#f5e0dc,hl:#f38ba8 \
          --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
          --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
          --color=selected-bg:#45475a,border:#6c7086"
      else
        export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
          --color=bg+:#ccd0da,bg:-1,spinner:#dc8a78,hl:#d20f39 \
          --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
          --color=marker:#7287fd,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39 \
          --color=selected-bg:#bcc0cc,border:#9ca0b0"
      fi

      # Delta theme (overrides default feature when light)
      [ "$_APPEARANCE" = "light" ] && export DELTA_FEATURES=catppuccin-latte

      # Zellij theme
      alias zellij="command zellij options --theme catppuccin-$_APPEARANCE"

      # Machine-local config — never committed; keep credentials,
      # work identities, and host-specific hacks there.
      [ -f ~/.zshrc.local ] && source ~/.zshrc.local
    '';
  };

  # Hosts, identities, and keys are machine-local — never in this repo.
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "~/.ssh/config.local" ];
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

      directory = {
        truncation_length = 3;
        truncate_to_repo = false;
        style = "bold cyan";
      };

      git_branch.style = "bold blue";

      git_status.style = "bold yellow";

      kubernetes = {
        disabled = false;
        symbol = "⎈ ";
        style = "bold blue";
        format = "[$symbol$context( \\($namespace\\))]($style) ";
      };

      nix_shell = {
        heuristic = true;
        symbol = "❄️ ";
        style = "bold cyan";
        format = "[$symbol]($style) ";
      };

      cmd_duration = {
        min_time = 2000;
        style = "bold yellow";
      };
    };
  };

  programs.ghostty = {
    enable = true;
    package = null; # config only — the app is a homebrew cask on macOS (modules/darwin.nix)
    systemd.enable = false; # requires a package; incompatible with package = null
    enableZshIntegration = true;
    settings = {
      font-family = "FiraCode Nerd Font Mono";
      font-size = 14;
      font-thicken = true;
      adjust-cell-height = "10%";
      theme = "light:Catppuccin Latte,dark:Catppuccin Mocha"; # built-in themes
      background-opacity = 0.55;
      background-blur = 12;
      mouse-hide-while-typing = true;
      desktop-notifications = true;
      window-padding-color = "extend";
      window-padding-x = 4;
      window-padding-y = 2;
      tab-inherit-working-directory = true;
      window-inherit-working-directory = true;
      window-inherit-font-size = true;
      window-save-state = "always";
      clipboard-trim-trailing-spaces = true;
      cursor-click-to-move = true;
      shell-integration-features = "sudo,title,ssh-env,ssh-terminfo";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    # atuin owns Ctrl-R; fzf keeps Ctrl-T (files) and Alt-C (cd)
    historyWidget.command = "";
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
    config.theme = "ansi";
  };

  programs.fd.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = user.name;
      user.email = user.email;
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rebase.autoStash = true;
      merge.conflictstyle = "zdiff3";
      diff.algorithm = "histogram";
      rerere.enabled = true;
      fetch.prune = true;
      credential.helper =
        lib.optionals isDarwin [ "osxkeychain" ]
        ++ lib.optionals (!isDarwin) [ "cache --timeout 86400" ]
        ++ [ "oauth" ];
      alias = {
        st = "status -sb";
        amend = "commit --amend --no-edit";
        undo = "reset --soft HEAD~1";
      };
    };
    # Credentials, work identities (includeIf), private remotes
    includes = [ { path = "~/.gitconfig.local"; } ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
      features = "catppuccin-mocha";

      catppuccin-mocha = {
        dark = true;
        syntax-theme = "Catppuccin Mocha";
        minus-style = "syntax #493447";
        minus-emph-style = "bold syntax #694559";
        plus-style = "syntax #394545";
        plus-emph-style = "bold syntax #4e6356";
        line-numbers-minus-style = "bold #f38ba8";
        line-numbers-plus-style = "bold #a6e3a1";
        line-numbers-zero-style = "#6c7086";
        line-numbers-left-style = "#6c7086";
        line-numbers-right-style = "#6c7086";
        blame-palette = "#1e1e2e #181825 #11111b #313244 #45475a";
      };

      catppuccin-latte = {
        light = true;
        syntax-theme = "Catppuccin Latte";
        minus-style = "syntax #e9c4cf";
        minus-emph-style = "bold syntax #e5a2b3";
        plus-style = "syntax #cce1cd";
        plus-emph-style = "bold syntax #b2d5ae";
        line-numbers-minus-style = "bold #d20f39";
        line-numbers-plus-style = "bold #40a02b";
        line-numbers-zero-style = "#9ca0b0";
        line-numbers-left-style = "#9ca0b0";
        line-numbers-right-style = "#9ca0b0";
        blame-palette = "#eff1f5 #e6e9ef #dce0e8 #ccd0da #bcc0cc";
      };
    };
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "yy"; # keep legacy wrapper name (home.stateVersion < 26.05)
  };

  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      theme_background = false; # Transparent background
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        nerdFontsVersion = "3";
        theme = {
          activeBorderColor = [
            "blue"
            "bold"
          ];
          inactiveBorderColor = [ "white" ];
          optionsTextColor = [ "blue" ];
          selectedLineBgColor = [ "default" ];
          cherryPickedCommitBgColor = [ "default" ];
          cherryPickedCommitFgColor = [ "blue" ];
          unstagedChangesColor = [ "red" ];
          defaultFgColor = [ "default" ];
          searchingActiveBorderColor = [ "yellow" ];
        };
        authorColors."*" = "blue";
      };
      git.pagers = [
        {
          pager = "delta --paging=never";
          colorArg = "always";
        }
      ];
    };
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ]; # Ctrl-R only; arrows are zsh's (initContent)
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

  home.sessionPath = [ "$HOME/.local/bin" ];

  # k9s — XDG on every platform (its macOS default is ~/Library/Application
  # Support) so config and cluster state live in one place. Skin is the
  # upstream Catppuccin port.
  home.sessionVariables.K9S_CONFIG_DIR = "${config.xdg.configHome}/k9s";
  xdg.configFile = {
    "k9s/config.yaml".source = (pkgs.formats.yaml { }).generate "k9s-config.yaml" {
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
    "k9s/skins/catppuccin-mocha-transparent.yaml".source =
      let
        catppuccin = pkgs.catppuccin.override {
          variant = "mocha";
          themeList = [ "k9s" ];
        };
      in
      "${catppuccin}/k9s/catppuccin-mocha-transparent.yaml";
  };
}
