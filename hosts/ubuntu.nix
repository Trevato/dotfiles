# Ubuntu-specific configuration (standalone home-manager)
{
  pkgs,
  lib,
  ...
}:
{
  home.stateVersion = "25.11";
  home.homeDirectory = "/home/trevato";

  home.packages = with pkgs; [
    docker-compose
    lazydocker
    kubectl
    kubernetes-helm
    helmfile
    k9s
    kustomize
    wireguard-tools
  ];

  # Font config for Linux (fontconfig picks these up automatically)
  fonts.fontconfig.enable = true;
  home.packages =
    lib.mkAfter
      (with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        nerd-fonts.symbols-only
      ]);
}
