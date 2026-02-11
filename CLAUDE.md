# dotfiles

Trevato's macOS configuration — nix-darwin + home-manager for a fully declarative dev environment.

## Structure

```
flake.nix                    # Entry point
hosts/mac.nix                # Host-specific config
modules/
  darwin.nix                 # System packages, services
  home.nix                   # User environment, shell, tools
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
