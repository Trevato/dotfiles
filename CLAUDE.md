# dotfiles

Trevato's personal configuration — nix-darwin (macOS) + standalone home-manager (Ubuntu) for a fully declarative dev environment.

## Structure

```
flake.nix                    # Entry point
hosts/
  mac.nix                    # macOS host config
  ubuntu.nix                 # Ubuntu host config
modules/
  darwin.nix                 # macOS system packages, services
  linux.nix                  # Linux user packages (standalone home-manager)
  home.nix                   # Shared user environment, shell, tools
  home-linux.nix             # Linux overrides for home.nix
  nixvim.nix                 # Neovim configuration
  minecraft.nix              # Prism Launcher + JDK
  secrets.nix                # Agenix secrets
secrets/
  *.age                      # Encrypted secrets
```

## Rebuild

```bash
# macOS
darwin-rebuild switch --flake .#otavert-mac

# Ubuntu
home-manager switch --flake .#trevato@ubuntu
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
- `modules/home-linux.nix` — `home.homeDirectory` override
- `hosts/mac.nix` — hostname
- `hosts/ubuntu.nix` — packages, home directory
- `flake.nix` — `darwinConfigurations` / `homeConfigurations` keys
- `modules/secrets.nix` — agenix keys (or remove)
- `modules/nixvim.nix` — dashboard header ASCII art and links
- `modules/nixvim.nix` — dashboard TUI launcher commands (lazygit, lazydocker, k9s, btop, claude)

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
- **Flake targets**: `aarch64-darwin` (macOS), `x86_64-linux` (Ubuntu)
- **Commit style**: lowercase, concise
