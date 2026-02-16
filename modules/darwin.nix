# Shared darwin system configuration
{
  pkgs,
  lib,
  self,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    git
    gh
    curl
    jq
    ripgrep
    tree
    lazygit
    gcc
    gnumake
    claude-code
    bun
    starship
    nixfmt-rfc-style
    prettierd
    stylua
    direnv
    inputs.agenix.packages.${pkgs.system}.default
    tailscale
    tldr
    uv
    just
    watchexec
    sd
    xh
  ];

  services.tailscale.enable = true;

  nix.settings.experimental-features = "nix-command flakes";
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
      "discord"
    ];

  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;

  system.defaults.CustomUserPreferences = {
    "com.apple.Safari" = {
      # Developer tools
      IncludeDevelopMenu = true;
      WebKitDeveloperExtrasEnabledPreferenceKey = true;
      "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;

      # Show full URL in address bar
      ShowFullURLInSmartSearchField = true;

      # Auto-hide toolbar in full screen
      AutoShowToolbarInFullScreen = false;

      # Show status bar overlay (hover link previews)
      ShowOverlayStatusBar = true;
    };

    "com.apple.Safari.SandboxBroker" = {
      ShowDevelopMenu = true;
    };
  };

  programs.zsh.enable = true;
}
