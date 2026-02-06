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

  # Internal platform services - bypass public DNS IPv6
  environment.etc.hosts.text = ''
    ##
    # Host Database
    ##
    127.0.0.1       localhost
    255.255.255.255 broadcasthost
    ::1             localhost

    # Platform services (IPv4)
    10.0.0.53 gitea.internal.product-garden.com
    10.0.0.53 ci.internal.product-garden.com
    10.0.0.53 minio.internal.product-garden.com
    10.0.0.53 langfuse.internal.product-garden.com
    10.0.0.53 headlamp.internal.product-garden.com

    # Block IPv6 (force IPv4)
    ::0 gitea.internal.product-garden.com
    ::0 ci.internal.product-garden.com
    ::0 minio.internal.product-garden.com
    ::0 langfuse.internal.product-garden.com
    ::0 headlamp.internal.product-garden.com
  '';

  nix.settings.experimental-features = "nix-command flakes";
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
      "discord"
    ];

  programs.zsh.enable = true;
}
