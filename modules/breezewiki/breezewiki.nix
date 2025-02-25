{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  libz,
  lz4,
}:

stdenv.mkDerivation {
  pname = "breezewiki";
  version = "20250108172305";

  src = fetchurl {
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
}
