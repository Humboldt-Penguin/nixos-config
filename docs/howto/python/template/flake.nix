{

  description = "Python development environment with FHS and uv (github.com/astral-sh/uv).";
  # Credit/inspiration/reference: https://www.alexghr.me/blog/til-nix-flake-fhs/


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };


  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      fhs = pkgs.buildFHSEnv {
        name = "fhs-shell";
        targetPkgs = pkgs: with pkgs; [
          uv
          zlib    # required to make numpy work ("C-extensions" nonsense)
          just    # task-runner, see associated '.justfile'
        ];
      };
    in
      {
        devShells.${system}.default = fhs.env;
      };
}
