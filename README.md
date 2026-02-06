# nix-darwin-config

Unified Nix configuration for my Mac and VXRail homelab server. One repo, two machines, declarative everything.

## Machines

### otavert-mac (macOS)
Daily driver. nix-darwin + home-manager for dev tools, Neovim, Homebrew casks, and a Minecraft server because why not.

### otavert-vxrail (NixOS)
Dell VXRail node repurposed as a homelab — 2x Xeon Gold 6230, 256GB RAM, running k3s. Hosts a self-hosted web platform for shipping side projects without touching Vercel or GitHub.

## The Platform

A one-command workflow for deploying Next.js apps to my own infrastructure:

```
push to Gitea → build Docker image → deploy to k3s → live at *.product-garden.com
```

### Quick start (on the server)

```bash
# Spin up a new project
just new my-app

# What's running?
just status
just list

# Tear it down
just destroy my-app
```

`just new` scaffolds a Next.js app, creates a Gitea repo, builds a Docker image, pushes it to Gitea's container registry, deploys to k3s, and makes it publicly accessible through a Cloudflare Tunnel. One command, zero YAML editing.

### Stack

| Layer | Tool | What it does |
|-------|------|-------------|
| Source control | Gitea | Git hosting + OCI container registry |
| CI/CD | Woodpecker CI | Gitea-native, builds on push |
| Orchestration | k3s | Lightweight Kubernetes |
| Ingress | Traefik v3 | Routes `*.product-garden.com` to pods |
| TLS + DNS | Cloudflare Tunnel | Zero-config HTTPS, no certs to manage |
| Storage | MinIO | S3-compatible object storage per project |
| Database | PostgreSQL | Per-project databases via `platform create-db` |

### How it works

Every project gets:
- A Gitea repository with CI/CD pipeline
- A multi-stage Docker build (Next.js standalone output)
- Kubernetes deployment, service, and ingress
- A public URL at `https://<project>.product-garden.com`

The platform infrastructure is declared as NixOS modules in `modules/platform/`. Traefik, Cloudflare Tunnel, Woodpecker CI, and MinIO are all deployed via k3s manifests that NixOS manages declaratively — `nixos-rebuild switch` and the cluster converges.

## Structure

```
flake.nix              Entry point
hosts/
  mac.nix              macOS-specific config
  vxrail.nix           Server config + platform secrets
modules/
  darwin.nix           macOS system (Homebrew, services)
  nixos.nix            NixOS system (k3s, SSH, users)
  home.nix             macOS home-manager
  home-vxrail.nix      Server home-manager
  nixvim.nix           Neovim config
  platform/            Self-hosted web platform modules
templates/             Project scaffolding (Dockerfile, k8s, CI)
justfile               Platform management recipes
```

## Rebuilding

```bash
# macOS
darwin-rebuild switch --flake .#otavert-mac

# Server
sudo nixos-rebuild switch --flake ~/nix-darwin-config#otavert-vxrail
```
