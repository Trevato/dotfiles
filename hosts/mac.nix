# Mac-specific configuration (otavert-mac)
{ pkgs, user, ... }:
{
  # Mac-only packages — the container runtime and desktop apps. Portable CLI
  # tools (including the Kubernetes toolbox) live in modules/home.nix.
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

  nixpkgs.hostPlatform = "aarch64-darwin";
  security.pam.services.sudo_local.touchIdAuth = true;
  nix.enable = false; # Required for Determinate Systems installer
  users.users.${user.username}.home = "/Users/${user.username}";
  system.primaryUser = user.username;

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
