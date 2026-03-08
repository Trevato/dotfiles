# dotfiles

My personal configuration — nix-darwin (macOS) + standalone home-manager (Ubuntu) for a fully declarative dev environment.

## What's included

- **Shell**: zsh with starship, fzf, zoxide, atuin
- **Editor**: Neovim via nixvim
- **Git**: delta, lazygit, sensible defaults
- **Terminal**: ghostty, zellij
- **Kubernetes**: kubectl, helm, k9s (+ colima on macOS) ([guide](docs/kubernetes.md))
- **Tools**: direnv, eza, bat, ripgrep, fd, yazi, btop

## Platforms

| Platform | Config type | Rebuild command |
|----------|------------|-----------------|
| macOS (aarch64) | nix-darwin | `darwin-rebuild switch --flake .#otavert-mac` |
| Ubuntu (x86_64) | home-manager standalone | `home-manager switch --flake .#trevato@ubuntu` |

## Make it yours

1. **Fork/clone** this repo

2. **Update the hostname/user** in `flake.nix`:
   ```nix
   # macOS
   darwinConfigurations."your-hostname" = ...;
   # Ubuntu
   homeConfigurations."you@ubuntu" = ...;
   ```

3. **Update user details** in `modules/home.nix`:
   ```nix
   home.homeDirectory = "/Users/your-username";  # or /home/...
   programs.git.settings.user.name = "your-name";
   programs.git.settings.user.email = "your@email.com";
   ```

4. **Update the host configs**:
   - `hosts/mac.nix` — macOS packages, system defaults
   - `hosts/ubuntu.nix` — Linux packages, home directory

5. **Remove my stuff** you don't need:
   - `modules/minecraft.nix` — Prism Launcher + JDK
   - `modules/secrets.nix` and `secrets/` — my encrypted keys
   - SSH config in `modules/home.nix` — my machines

6. **Rebuild**:
   ```bash
   # macOS
   darwin-rebuild switch --flake .#your-hostname
   # Ubuntu
   home-manager switch --flake .#you@ubuntu
   ```

## Usage

```bash
# Rebuild after changes (macOS)
darwin-rebuild switch --flake .#otavert-mac

# Rebuild after changes (Ubuntu)
home-manager switch --flake .#trevato@ubuntu

# Format nix files
nix fmt
```

## Structure

```
flake.nix                # Entry point
hosts/
  mac.nix                # macOS host config
  ubuntu.nix             # Ubuntu host config
modules/
  darwin.nix             # macOS system packages, services
  linux.nix              # Linux user packages
  home.nix               # Shared user environment, shell, tools
  home-linux.nix         # Linux overrides for home.nix
  nixvim.nix             # Neovim configuration
```
