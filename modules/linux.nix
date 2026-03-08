# Shared packages and config for Linux (standalone home-manager)
#
# On macOS these live in darwin.nix as system packages. On Linux with
# standalone home-manager we install them as user packages instead.
{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    git
    gh
    curl
    jq
    yq
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
}
