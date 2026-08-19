# dotfiles

[![check](https://github.com/trevato/dotfiles/actions/workflows/check.yml/badge.svg)](https://github.com/trevato/dotfiles/actions/workflows/check.yml)

A portable development environment — one flake, any machine, at home in minutes.

- **Shell**: zsh + starship, fzf, zoxide, atuin, eza, bat, fd
- **Editor**: Neovim via nixvim — LSP, treesitter, telescope, dashboard ([manual](docs/nvim.md))
- **Claude Code**: instructions, output style, agents, hooks, statusline ([`claude/`](claude))
- **Git**: delta, lazygit, sensible defaults
- **Terminal**: ghostty, zellij, yazi, btop
- **Toolbox**: gh, jq, yq, ripgrep, bun, node, uv, just, watchexec, sd, xh, kubectl, helm, k9s, flux

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
# 1. Nix, and Homebrew for the two GUI casks (Ghostty, Spotify)
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. First switch bootstraps nix-darwin (the host name is the `hostname` in flake.nix)
git clone https://github.com/trevato/dotfiles ~/dotfiles
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/dotfiles#otavert-mac
```

From then on it's `nrs`. Claude Code itself is the native installer
(self-updating): `curl -fsSL https://claude.ai/install.sh | bash`.

### Day to day

The repo is operated through its [`justfile`](justfile) — `just` lists the recipes.
Two aliases cover the common ones from anywhere: `nrs` applies (`just switch`),
`nfu` updates inputs (`just update`); both expect the clone at `~/dotfiles`.
`just check` evaluates every configuration for every system; CI runs the same
on every push, on Linux and macOS runners.

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

Claude Code's own state (`~/.claude/projects`, sessions, `settings.local.json`)
stays local too; only the curated configuration is linked in from `claude/`.
Because `~/.claude/settings.json` is managed, changes Claude Code would make to
it (`/model`, `/output-style`, `/statusline`) go in `claude/settings.json`
followed by `nrs`.

## Make it yours

Fork, then edit the `user` block in `flake.nix` — username, git identity,
dashboard subtitle — and the darwin `hostname` beside it. Everything else reads
from there. `hosts/mac.nix` holds Mac-only packages and macOS defaults; a
Linux-only fork drops `darwinConfigurations` from `flake.nix` together with
`hosts/`, `modules/darwin.nix` and `modules/minecraft.nix`. `claude/` is yours
to rewrite.

## Structure

```
flake.nix              # Entry point: identity, darwin system, per-arch home-manager, checks
justfile               # switch / update / check / fmt
modules/
  home.nix             # Portable user environment — shell, git, tools (all platforms)
  nixvim.nix           # Neovim configuration
  claude.nix           # Links claude/ into ~/.claude
  darwin.nix           # macOS system packages, services, defaults
  minecraft.nix        # Optional: Prism Launcher + JDK
hosts/mac.nix          # Mac host specifics
claude/                # Claude Code: CLAUDE.md, settings, output style, agents, hook scripts
lib/ascii-banner.nix   # Dashboard banner renderer
docs/nvim.md           # Neovim manual
.github/workflows/     # CI: evaluate every configuration, check formatting
```

## Conventions

- **Formatting**: `nix fmt` (nixfmt via treefmt); CI enforces it
- **Commit style**: lowercase, concise, imperative
