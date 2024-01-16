# Override nixos package because it does not follow the expected format
{ lib
, stdenvNoCC
, fetchFromGitHub
, unzip
}:

stdenvNoCC.mkDerivation rec {
  pname = "my-catppuccin-cursors";
  version = "0.2.0";
  dontBuild = true;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "cursors";
    rev = "v${version}";
    sha256 = "sha256-TgV5f8+YWR+h61m6WiBMg3aBFnhqShocZBdzZHSyU2c=";
    sparseCheckout = [ "cursors" ];
  };

  nativeBuildInputs = [ unzip ];

  outputsToInstall = [];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/icons"

    for iconZip in cursors/*.zip; do
      unzip "$iconZip" -d "$out/share/icons"
    done

    runHook postInstall
  '';

  # meta = with lib; {
  #   description = "Catppuccin cursor theme based on Volantes";
  #   homepage = "https://github.com/catppuccin/cursors";
  #   license = licenses.gpl2;
  #   platforms = platforms.linux;
  #   maintainers = with maintainers; [ PlayerNameHere ];
  # };
}
