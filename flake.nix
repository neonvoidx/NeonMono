{
  description = "Custom Iosevka font build — NeonMono";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    iosevka-upstream = {
      url = "github:be5invis/Iosevka?ref=refs/tags/v34.3.0";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    systems = ["x86_64-linux" "aarch64-linux"];
    forEachSystem = nixpkgs.lib.genAttrs systems;
    pkgsForEach = nixpkgs.legacyPackages;
  in {
    packages = forEachSystem (system: let
      pkgs = pkgsForEach.${system};
    in {
      default = pkgs.callPackage ./nix/neonmono-base.nix {inherit inputs self;};
    });

    hydraJobs = self.packages;
  };
}
