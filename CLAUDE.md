# Nix Darwin Config (Mac Branch)

Trevato's macOS personal configuration — nix-darwin + home-manager for a fully declarative development environment.

## Structure

```
flake.nix                    # Entry point: darwin configuration
hosts/
  mac.nix                    # Host-specific config (otavert-mac)
modules/
  darwin.nix                 # macOS system: Homebrew, services
  home.nix                   # home-manager: GUI apps, dev tools
  nixvim.nix                 # Neovim configuration
  minecraft.nix              # Minecraft server module
  secrets.nix                # Agenix secrets
secrets/
  *.age                      # Encrypted secrets
```

## Rebuild

```bash
darwin-rebuild switch --flake .#otavert-mac
```

## Format

```bash
nix fmt
```

## Conventions

- **Nix formatting**: `nixfmt-rfc-style` (via `nix fmt`)
- **Flake target**: `aarch64-darwin`
- **Commit style**: lowercase, concise

## Related

This is the **mac** branch containing only macOS configuration.
The **platform** branch contains the OpenPlatform agent ecosystem for NixOS servers.
