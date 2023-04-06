# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2003-2023 the Nixpkgs/NixOS contributors
{ lib, src, stdenv
, alsa-lib, flac, libmad
, libpulseaudio
, libvorbis
, mpg123
, audioBackend ? "alsa"
, dsdSupport ? true
, faad2Support ? true
, faad2
, ffmpegSupport ? true
, ffmpeg
, opusSupport ? true
, opusfile
, resampleSupport ? true
, soxr
, sslSupport ? true
, openssl
}:

let
  inherit (lib) optionalString optionals;
  binName = "squeezelite${optionalString pulseSupport "-pulse"}";
  pulseSupport = audioBackend == "pulse";
in stdenv.mkDerivation {
  # the NixOS module uses the pname as the binary name
  pname = binName;
  # versions are specified in `squeezelite.h`
  # see https://github.com/ralph-irving/squeezelite/issues/29
  version = lib.fileContents ../../../project_version.txt;

  inherit src;

  buildInputs = [
    flac
    libmad
    libvorbis
    mpg123
  ] ++ (if pulseSupport then [
    libpulseaudio
  ] else [
    alsa-lib
  ]) ++ optionals faad2Support [
    faad2
  ] ++ optionals ffmpegSupport [
    ffmpeg
  ] ++ optionals opusSupport [
    opusfile
  ] ++ optionals resampleSupport [
    soxr
  ] ++ optionals sslSupport [
    openssl
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace opus.c \
      --replace "<opusfile.h>" "<opus/opusfile.h>"
  '';

  EXECUTABLE = binName;

  OPTS = [ "-DLINKALL" "-DGPIO" ] ++
    optionals dsdSupport [ "-DDSD" ] ++
    optionals (!faad2Support) [ "-DNO_FAAD" ] ++
    optionals ffmpegSupport [ "-DFFMPEG" ] ++
    optionals opusSupport [ "-DOPUS" ] ++
    optionals pulseSupport [ "-DPULSEAUDIO" ] ++
    optionals resampleSupport [ "-DRESAMPLE" ] ++
    optionals sslSupport [ "-DUSE_SSL" ];

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin                   ${binName}
    install -Dm444 -t $out/share/doc/squeezelite *.txt *.md

    runHook postInstall
  '';

  meta = {
    description = "Lightweight headless squeezebox client emulator";
    homepage = "https://github.com/ralph-irving/squeezelite";
    license = let l = lib.licenses; in [ l.gpl3Plus ] ++ optionals dsdSupport [ l.bsd2 ];
    maintainers = let m = lib.maintainers; in [ m.adamcstephens m.bb010g ];
    platforms = lib.platforms.linux;
  };
}
