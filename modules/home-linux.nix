# Linux home-manager entry point
#
# Imports the shared home.nix and overrides darwin-specific bits.
{
  pkgs,
  lib,
  ...
}:
{
  imports = [ ./home.nix ];

  # Override the macOS home directory
  home.homeDirectory = lib.mkForce "/home/trevato";

  # Drop darwin-only SSH includes
  programs.ssh.includes = lib.mkForce [ ];

  # Ghostty: use the actual package on Linux
  programs.ghostty.package = lib.mkForce pkgs.ghostty;
}
