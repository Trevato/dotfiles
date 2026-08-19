# Darwin system configuration — system services, defaults, and packages that
# must be system-level. Portable dev tools live in modules/home.nix.
{
  pkgs,
  lib,
  self,
  ...
}:
{
  # No C toolchain here: nixpkgs gcc would shadow Apple's cc/c++ system-wide.
  # Projects that need one get it from a devShell.
  environment.systemPackages = with pkgs; [
    git
    tailscale
    spotify-player
  ];

  services.tailscale.enable = true;

  # dnsmasq for local k8s wildcard DNS (loopback only)
  services.dnsmasq.enable = true;
  services.dnsmasq.addresses = {
    "dev.test" = "127.0.0.1";
    "plat.local" = "127.0.0.1"; # plat daughter (k3d on colima; traefik on host 80/443)
  };

  # nix-darwin's HTML manual build breaks against current nixpkgs-unstable
  # (nixos-render-docs removed --toc-depth); the manual lives online anyway.
  # The uninstaller tool embeds a stock-config system that rebuilds that same
  # manual, so it has to go too (still available: nix run nix-darwin#darwin-uninstaller).
  documentation.doc.enable = false;
  system.tools.darwin-uninstaller.enable = false;

  # nix.conf is Determinate's (nix.enable = false in hosts/mac.nix); flakes are on there.
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
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

  # GUI apps that nixpkgs doesn't ship well on macOS. Ghostty's config is
  # home-manager's (modules/home.nix); the app itself comes from here.
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    casks = [
      "ghostty"
      "spotify"
    ];
  };

  programs.zsh.enable = true;
}
