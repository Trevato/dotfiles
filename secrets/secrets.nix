let
  trevato-mac = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTsX/en0v5Ie12PSaz1ePYVxhsGqG/plUDwR3qU14et trevato@otavert-mac";
in
{
  "vxrail-ssh.age".publicKeys = [ trevato-mac ];
  "docker-config.age".publicKeys = [ trevato-mac ];
  "wireguard.age".publicKeys = [ trevato-mac ];
  "tailscale-authkey.age".publicKeys = [ trevato-mac ];
}
