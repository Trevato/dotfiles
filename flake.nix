{
  description = "Trevato's personal configuration — macOS + Ubuntu";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nix-direnv.url = "github:nix-community/nix-direnv";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    claude-code.url = "github:sadjow/claude-code-nix";
    claude-config = {
      url = "github:trevato/.claude";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      agenix,
      ...
    }:
    {
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      # macOS (nix-darwin)
      darwinConfigurations."otavert-mac" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs self; };
        modules = [
          { nixpkgs.overlays = [ inputs.claude-code.overlays.default ]; }
          agenix.darwinModules.default
          ./modules/darwin.nix
          ./modules/minecraft.nix
          ./modules/secrets.nix
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

      # Ubuntu (standalone home-manager)
      homeConfigurations."trevato@ubuntu" =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ inputs.claude-code.overlays.default ]; }
            ./modules/linux.nix
            ./modules/home-linux.nix
            ./hosts/ubuntu.nix
          ];
        };
    };
}
