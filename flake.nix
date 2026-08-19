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
      # Identity lives here and nowhere else; every module reads from `user`.
      user = {
        username = "trevato"; # login name — home directory, home-manager, darwin primary user
        name = "trevato"; # git author
        email = "me@trevato.dev";
        site = "trevato.dev"; # nvim dashboard subtitle
        github = "trevato";
      };
      hostname = "otavert-mac";

      linuxSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forLinux = nixpkgs.lib.genAttrs linuxSystems;
    in
    {
      formatter = nixpkgs.lib.genAttrs ([ "aarch64-darwin" ] ++ linuxSystems) (
        system: nixpkgs.legacyPackages.${system}.nixfmt-tree
      );

      # macOS — full system (nix-darwin + home-manager as a module)
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs self user; };
        modules = [
          ./modules/darwin.nix
          ./modules/minecraft.nix
          ./hosts/mac.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs user; };
            home-manager.users.${user.username} = import ./modules/home.nix;
          }
        ];
      };

      # Any Linux box — standalone home-manager (jumpbox, Raspberry Pi, VM)
      homeConfigurations = builtins.listToAttrs (
        map (system: {
          name = "${user.username}@${system}";
          value = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            extraSpecialArgs = { inherit inputs user; };
            modules = [ ./modules/home.nix ];
          };
        }) linuxSystems
      );

      # `nix flake check --no-build --all-systems` evaluates all of them (just check, CI)
      checks =
        forLinux (system: {
          home = self.homeConfigurations."${user.username}@${system}".activationPackage;
        })
        // {
          aarch64-darwin.darwin = self.darwinConfigurations.${hostname}.system;
        };
    };
}
