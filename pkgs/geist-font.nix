{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "geist-font";
  version = "1.1.0";

  srcs = [
    (fetchzip {
      url = "https://github.com/vercel/geist-font/releases/download/${version}/Geist.zip";
      hash = "sha256-nSN+Ql5hTd230w/u6VZyAZaPtFSaHGmMc6T1fgGTCME=";
      stripRoot = false;
    })
    (fetchzip {
      url = "https://github.com/vercel/geist-font/releases/download/${version}/Geist.Mono.zip";
      hash = "sha256-8I4O2+bJAlUiDIhbyXzAcwXP5qpmHoh4IfrFio7IZN8=";
      stripRoot = false;
    })
  ];

  dontUnpack = true;

  installPhase = ''
    find $srcs -name '*.otf' | xargs install -m664 --target $out/share/fonts/truetype -D
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "sha256-o0udK8JrM/KIN6HgyBbo2mn/cC8D6kqAAh0b4idfgH4=";
}
