# Operate this repo — `just` lists the recipes.

[private]
default:
    @just --list --unsorted

# Apply the configuration to this machine
[macos]
switch:
    sudo darwin-rebuild switch --flake .

# Apply the configuration to this machine
[linux]
switch:
    home-manager switch -b backup --flake ".#$USER@$(nix config show system)"

# Update flake inputs
update:
    nix flake update

# Evaluate every configuration, for every system, without building
check:
    nix flake check --no-build --all-systems

# Format Nix files
fmt:
    nix fmt
