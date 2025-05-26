{
  description = "Keep local-only changes on top of Git branches.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    let
      inherit (inputs) self flake-parts;
      inherit (self.lib) makeOverridable;
    in
    flake-parts.lib.mkFlake { inherit inputs; } (top: {
      systems = [
        "x86_64-linux"
      ];
      imports = [
        ./lib.nix
      ];
      perSystem =
        { pkgs, ... }:
        {
          packages = rec {
            git-overlay = makeOverridable (import ./package.nix) { inherit pkgs inputs; };
            default = git-overlay;
          };
        };
    });
}
