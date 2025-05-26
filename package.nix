{
  lib,
  stdenv,
  coreutils,
  git,
  gnugrep,
  gnused,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "git-overlay";
  version = "0.1.0";

  src = ./.;
  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a git-* $out/bin/
  '';

  wrapperPath = lib.makeBinPath [
    coreutils
    git
    gnugrep
    gnused
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
