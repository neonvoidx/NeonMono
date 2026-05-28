# NeonMono

Custom Iosevka font build with personal twists. Based on the [Iosevka](https://typeof.net/Iosevka) customizer template.

## Building

This flake provides a **single default package** — NeonMono.

```bash
nix build .#default -Lv
```

## Installing

Add the flake as an input to your system configuration:

```nix
neonmono = {
  url = "github:neonvoidx/NeonMono";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Then add the package to your `fonts.packages`:

```nix
fonts.packages = with pkgs; [
  (inputs.neonmono.packages.${pkgs.system}.default)
];
```

To use fontconfig, refer to the font by its family name:

```
font = "NeonMono:size=15";
```
