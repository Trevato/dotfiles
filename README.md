# dotfiles

A portable development environment — one flake, any machine, at home in minutes.

- **Shell**: zsh + starship, fzf, zoxide, atuin, eza, bat, fd
- **Editor**: Neovim via nixvim — LSP, treesitter, telescope, dashboard ([manual](docs/nvim.md))
- **Git**: delta, lazygit, sensible defaults
- **Terminal**: ghostty, zellij, yazi, btop
- **Toolbox**: gh, jq, yq, ripgrep, bun, node, uv, just, watchexec, sd, xh

Catppuccin everywhere — Mocha in the dark, Latte in the light.

## Quick start

### Any Linux box — server, jumpbox, Raspberry Pi

```bash
# 1. Install Nix (skip if present)
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# 2. Apply the environment (use trevato@aarch64-linux on ARM/Pi)
nix run home-manager -- switch -b backup --flake github:trevato/dotfiles#trevato@x86_64-linux
```

That's it — open a new shell and you're home.

### macOS — full system via nix-darwin

```bash
git clone https://github.com/trevato/dotfiles ~/dotfiles
sudo darwin-rebuild switch --flake ~/dotfiles
```

After the first switch: `nrs` rebuilds, `nfu` updates flake inputs.

## Machine-local config

Anything private or machine-specific stays out of this repo. Three local files
are sourced/included if they exist — create them per machine:

| File                  | Purpose                                             |
| --------------------- | --------------------------------------------------- |
| `~/.zshrc.local`      | machine-specific shell config, sourced last         |
| `~/.gitconfig.local`  | credentials, work identities (`includeIf`), remotes |
| `~/.ssh/config.local` | hosts, users, and keys                              |

This is the portability contract: the repo carries the environment, the machine
carries its secrets.

## Make it yours

Fork, then update:

- `modules/home.nix` — `home.username`, `home.homeDirectory`, and `user.name` / `user.email` under `programs.git`
- `flake.nix` — the `trevato@…` keys in `homeConfigurations`, and the darwin hostname (`otavert-mac`)
- `modules/nixvim.nix` — `dashboardName` and `dashboardSubtitle` in the top-level `let` block
- `hosts/mac.nix` — Mac-only packages and macOS defaults (or delete if Linux-only)

## Structure

```
flake.nix              # Entry point: darwin system + per-arch home-manager configs
modules/
  home.nix             # Portable user environment — shell, git, tools (all platforms)
  nixvim.nix           # Neovim configuration
  darwin.nix           # macOS system packages, services, defaults
  minecraft.nix        # Optional: Prism Launcher + JDK
hosts/mac.nix          # Mac host specifics
lib/ascii-banner.nix   # Dashboard banner renderer
docs/                  # Neovim manual, local k8s guide
```

## Conventions

- **Formatting**: `nixfmt-rfc-style` via `nix fmt`
- **Commit style**: lowercase, concise, imperative
