{
  inputs,
  pkgs,
}:

let
  inherit (inputs.nixpkgs) lib;
in

pkgs.stdenv.mkDerivation rec {
  pname = "git-overlay";
  version = "0.1.0";

  src = ./.;
  nativeBuildInputs = [ pkgs.makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a git-* $out/bin/
  '';

  wrapperPath = lib.makeBinPath [
    pkgs.coreutils
    pkgs.git
    pkgs.gnugrep
    pkgs.gnused
  ];

  postFixup = ''
    wrap_path="${wrapperPath}":$out/bin

    wrapProgram $out/bin/git-overlay \
      --prefix PATH : $wrap_path
  '';

  meta = {
    description = "Keep local-only changes on top of Git branches.";
    homepage = "https://github.com/cdo256/git-overlay";
    license = lib.licenses.mit;
    platforms = with lib.platforms; unix;
  };
}
