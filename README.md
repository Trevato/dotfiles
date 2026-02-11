# dotfiles

My macOS configuration — nix-darwin + home-manager for a fully declarative dev environment.

## What's included

- **Shell**: zsh with starship, fzf, zoxide, atuin
- **Editor**: Neovim via nixvim
- **Git**: delta, lazygit, sensible defaults
- **Terminal**: ghostty, zellij
- **Tools**: direnv, eza, bat, ripgrep, fd, yazi, btop

## Make it yours

1. **Fork/clone** this repo

2. **Update the hostname** in `flake.nix`:
   ```nix
   darwinConfigurations."your-hostname" = darwin.lib.darwinSystem { ... };
   ```

3. **Update user details** in `modules/home.nix`:
   ```nix
   home.homeDirectory = "/Users/your-username";
   programs.git.settings.user.name = "your-name";
   programs.git.settings.user.email = "your@email.com";
   ```

4. **Update the host config** in `hosts/mac.nix`:
   ```nix
   networking.hostName = "your-hostname";
   users.users.your-username = { ... };
   home-manager.users.your-username = import ../modules/home.nix;
   ```

5. **Remove my stuff** you don't need:
   - `modules/minecraft.nix` — Prism Launcher + JDK
   - `modules/secrets.nix` and `secrets/` — my encrypted keys
   - SSH config in `modules/home.nix` — my machines

6. **Rebuild**:
   ```bash
   darwin-rebuild switch --flake .#your-hostname
   ```

## Usage

```bash
# Rebuild after changes
darwin-rebuild switch --flake .#your-hostname

# Format nix files
nix fmt
```

## Structure

```
flake.nix            # Entry point
hosts/mac.nix        # Host-specific config
modules/
  darwin.nix         # System packages, services
  home.nix           # User environment, shell, tools
  nixvim.nix         # Neovim configuration
```
