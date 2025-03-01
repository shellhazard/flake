{
  stdenv,
  lib,
  fetchurl,
  buildFHSEnv,
  autoPatchelfHook,
  libz,
  lz4,
}:

let
  pname = "breezewiki";
  version = "20250108172305";

  breezewiki = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      # No versioned URL is provided, so we use the archive.org version.
      url = "https://web.archive.org/web/20250108172305/https://docs.breezewiki.com/files/breezewiki-dist.tar.gz";
      hash = "sha256-PY+h6zLkGQMcMrlcB15rbU36bm7rKAQiJza1XAxhtow=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    buildInputs = [
      libz
      lz4
    ];

    sourceRoot = "./breezewiki-dist";

    installPhase = ''
      runHook preInstall
      ls -la
      install -m755 -D bin/dist $out/bin/breezewiki
      cp -R lib $out
      runHook postInstall
    '';

    meta = with lib; {
      homepage = "https://breezewiki.com/";
      description = "Fandom wiki proxy.";
      platforms = platforms.linux;
    };
  };
in

buildFHSEnv {
  name = pname;

  targetPkgs = pkgs: [
    breezewiki
  ];

  runScript = "./bin/breezewiki";
  extraInstallCommands = ''
    touch $out/test
  '';

  meta = with lib; {
    homepage = "https://breezewiki.com/";
    license = licenses.mit;
    description = "Fandom wiki proxy.";
    platforms = platforms.linux;
  };
}
