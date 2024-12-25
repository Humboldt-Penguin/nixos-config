{
  description = "...";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          just
          ...
        ];
      };
    in
      {
        devShells.${system}.default = devShell;
      };
}
