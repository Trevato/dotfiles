{
  description = "trevato's portable development environment — one flake for macOS and any Linux box";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      linuxSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    in
    {
      formatter = nixpkgs.lib.genAttrs ([ "aarch64-darwin" ] ++ linuxSystems) (
        system: nixpkgs.legacyPackages.${system}.nixfmt-tree
      );

      # macOS — full system (nix-darwin + home-manager as a module)
      darwinConfigurations."otavert-mac" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs self; };
        modules = [
          {
            nixpkgs.overlays = [
              (final: prev: {
                direnv = prev.direnv.overrideAttrs (old: {
                  env = (old.env or { }) // {
                    CGO_ENABLED = 1;
                  };
                });
              })
            ];
          }
          ./modules/darwin.nix
          ./modules/minecraft.nix
          ./hosts/mac.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.trevato = import ./modules/home.nix;
          }
        ];
      };

      # Any Linux box — standalone home-manager (jumpbox, Raspberry Pi, VM)
      homeConfigurations = builtins.listToAttrs (
        map (system: {
          name = "trevato@${system}";
          value = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            extraSpecialArgs = { inherit inputs; };
            modules = [ ./modules/home.nix ];
          };
        }) linuxSystems
      );
    };
}
