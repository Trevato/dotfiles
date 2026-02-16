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

  programs.zsh.enable = true;
}
