{
  description = "NixOS Configuration.";


  inputs = {

    nixpkgs.url          = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };


  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;

      /*
        Self note: this approach of enabling free/unfree in various channels is inspired by these:
            - toggle stable/unstable: https://librephoenix.com/2024-02-10-using-both-stable-and-unstable-packages-on-nixos-at-the-same-time
            - toggle free/unfree    : https://discourse.nixos.org/t/how-to-allow-unfree-for-unstable-packages/43600/4
        TODO:
            - Is it possible to rename `pkgs` to `pkgs-stable` at some point...?
      */
      pkgs                 = nixpkgs.legacyPackages.${system};
      pkgs-unstable        = nixpkgs-unstable.legacyPackages.${system};
      pkgs-stable-unfree   = import nixpkgs          { inherit system; config.allowUnfree = true; };
      pkgs-unstable-unfree = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };

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
            inherit pkgs-stable-unfree;
            inherit pkgs-unstable-unfree;
          };
        };
      };

    };
}
