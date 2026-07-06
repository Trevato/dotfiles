# Optional Minecraft module — Prism Launcher + JDK 21
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.minecraft;
in
{
  options.modules.minecraft.enable = lib.mkEnableOption "Minecraft with mod support";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      prismlauncher
      temurin-jre-bin-21
    ];
  };
}
