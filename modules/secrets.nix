{ config, lib, pkgs, ... }:
let
  secretsExist = true;
  isDarwin = pkgs.stdenv.isDarwin;
  homeDir = if isDarwin then "/Users/trevato" else "/home/trevato";
in
{
  age.identityPaths = [ "${homeDir}/.ssh/id_ed25519" ];

  age.secrets = lib.mkIf secretsExist {
    # Only needed on mac (to SSH into vxrail)
    vxrail-ssh = lib.mkIf isDarwin {
      file = ../secrets/vxrail-ssh.age;
      path = "${homeDir}/.ssh/vxrail";
      owner = "trevato";
      mode = "600";
    };

    # Shared secrets can go here
    # example-secret = {
    #   file = ../secrets/example.age;
    #   path = "${homeDir}/.config/example";
    #   owner = "trevato";
    #   mode = "600";
    # };
  };
}
