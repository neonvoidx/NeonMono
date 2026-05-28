{
  inputs,
  self,
  lib,
  buildNpmPackage,
  importNpmLock,
  remarshal,
  ttfautohint-nox,
  writableTmpDirAsHomeHook,
  ...
}: let
  inherit (lib.strings) concatStringsSep match;

  pname = "NeonMono";
  src = inputs.iosevka-upstream;
  version = concatStringsSep "-" (match "(.{4})(.{2})(.{2}).*" src.lastModifiedDate);

  targets = "ttf::${pname}";
in
  buildNpmPackage {
    inherit pname version;
    inherit src;

    npmDeps = importNpmLock {
      npmRoot = src.outPath;
    };

    npmConfigHook = importNpmLock.npmConfigHook;

    nativeBuildInputs = [
      remarshal
      ttfautohint-nox
      writableTmpDirAsHomeHook
    ];

    postPatch = ''
      install -Dm755 ${self + /plans/mono.toml} private-build-plans.toml
    '';

    enableParallelBuilding = true;
    buildPhase = ''
      runHook preBuild

      npm run build --no-update-notifier --targets ${targets} \
        -- --jCmd=$NIX_BUILD_CORES

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      fontdir="${placeholder "out"}/share/fonts/truetype"
      mkdir -p "$fontdir"
      install -Dm644 "dist/$pname/TTF"/* "$fontdir"

      runHook postInstall
    '';

    meta = {
      homepage = "https://typeof.net/Iosevka/";
      description = "Custom Iosevka font build — NeonMono";
      license = lib.licenses.ofl;
      platforms = lib.platforms.all;
    };
  }
