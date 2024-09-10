{
  description = "NixOS Configuration.";


  inputs = {

    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.05";
    };
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };


  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    in {

      nixosConfigurations = {
        wired = lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ];
          specialArgs = {
            inherit pkgs-unstable;
          };
        };
      };

      homeConfigurations = {
        lain = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            inherit pkgs-unstable;
          };
        };
      };

    };
}
