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
  minecraft.nix              # Prism Launcher + JDK
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

## Forking

If you fork this repo, update these to match your identity:

- `modules/home.nix` — `user.name`, `user.email` in `programs.git.settings`
- `modules/home.nix` — `programs.git.includes` for per-directory git identity (e.g. work repos using a different name/email)
- `modules/home.nix` — `home.homeDirectory`
- `hosts/mac.nix` — hostname
- `flake.nix` — `darwinConfigurations` key
- `modules/secrets.nix` — agenix keys (or remove)

### Work git identity

Git defaults to the personal identity everywhere. To use a different identity for work repos, add a conditional include in `programs.git.includes`:

```nix
includes = [
  {
    condition = "gitdir:~/projects/work/";
    contents = {
      user.name = "Your Name";
      user.email = "you@work.com";
    };
  }
];
```

Any repo cloned under that path will automatically use the work identity.

## Conventions

- **Nix formatting**: `nixfmt-rfc-style` (via `nix fmt`)
- **Flake target**: `aarch64-darwin`
- **Commit style**: lowercase, concise
