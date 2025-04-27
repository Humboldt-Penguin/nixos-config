{
  description = "Python development environment with Astral's `uv`. Note, this requires `nix-ld` enabled in system config.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          uv
        ];
      };
    in
      {
        devShells.${system}.default = devShell;
      };
}
