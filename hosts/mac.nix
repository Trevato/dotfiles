# Mac-specific configuration (otavert-mac)
{ pkgs, ... }:
{
  # Mac-only packages
  environment.systemPackages = with pkgs; [
    docker
    colima
    lazydocker
    discord
    wireguard-tools
  ];

  # Fonts (darwin-specific location)
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  modules.minecraft.enable = true;

  # Internal platform services (routed via Tailscale → MetalLB → Traefik)
  environment.etc.hosts.text = ''
    127.0.0.1 localhost
    255.255.255.255 broadcasthost
    ::1 localhost
    10.0.0.53 gitea.internal.product-garden.com ci.internal.product-garden.com minio.internal.product-garden.com
  '';

  nixpkgs.hostPlatform = "aarch64-darwin";
  security.pam.services.sudo_local.touchIdAuth = true;
  nix.enable = false; # Required for Determinate Systems installer
  users.users.trevato.home = "/Users/trevato";
  system.primaryUser = "trevato";

  # macOS system defaults
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";
      ShowPathbar = true;
    };
    NSGlobalDomain = {
      AppleKeyboardUIMode = 3;
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      AppleShowAllExtensions = true;
    };
    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };
    controlcenter.BatteryShowPercentage = true;
  };
}
