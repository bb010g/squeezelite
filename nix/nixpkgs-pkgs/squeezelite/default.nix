# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2003-2023 the Nixpkgs/NixOS contributors
{ lib, src, stdenv
, meson, ninja, pkg-config
  # Feature flags & optional dependencies
, withCodecAlac ? null, alac ? null
, withCodecDsd ? null
, withCodecFaad2 ? null, faad2 ? null
, withCodecFfmpeg ? null, ffmpeg ? null
, withCodecFlac ? null, flac ? null
, withCodecMad ? null, libmad ? null
, withCodecMpg123 ? null, mpg123 ? null
, withCodecOpus ? null, opusfile ? null
, withCodecPcm ? null
, withCodecVorbis ? null, libvorbis ? null
, withControlInfrared ? null, lirc ? null
, withGpio ? null
, withOutputAlsa ? null, alsa-lib ? null
, withOutputPortaudio ? null, portaudio ? null
, withOutputPulseaudio ? null, libpulseaudio ? null
, withOutputStdout ? null
, withOutputVisualizerExport ? null
, withRaspberryPi ? null
, withSampleProcessing ? null
, withSampleResampling ? null, soxr ? null
, withSampleResamplingMp ? null
, withSsl ? null, openssl
}:

let
  inherit (lib) getDev optionalString optionals;
  executableName = "squeezelite${executableNameSuffix}";
  executableNameSuffix = if mesonOptions.executable_name_suffix == "" then "" else
    "-${mesonOptions.executable_name_suffix}";
  mapNull = x: a: if a == null then x else a;
  mesonFeatures.codec_alac = mapNull true withCodecAlac;
  mesonFeatures.codec_dsd = mapNull true withCodecDsd;
  mesonFeatures.codec_faad2 = mapNull true withCodecFaad2;
  mesonFeatures.codec_flac = mapNull true withCodecFlac;
  mesonFeatures.codec_ffmpeg = mapNull true withCodecFfmpeg;
  mesonFeatures.codec_mad = mapNull true withCodecMad;
  mesonFeatures.codec_mpg123 = mapNull true withCodecMpg123;
  mesonFeatures.codec_opus = mapNull true withCodecOpus;
  mesonFeatures.codec_pcm = mapNull true withCodecPcm;
  mesonFeatures.codec_vorbis = mapNull true withCodecVorbis;
  mesonFeatures.control_infrared = mapNull false withControlInfrared;
  mesonFeatures.gpio = mapNull false withGpio;
  mesonFeatures.output_alsa = mapNull true withOutputAlsa;
  mesonFeatures.output_pulseaudio = mapNull false withOutputPulseaudio;
  mesonFeatures.output_portaudio = mapNull false withOutputPortaudio;
  mesonFeatures.output_stdout = mapNull true withOutputStdout;
  mesonFeatures.output_visualizer_export = mapNull false withOutputVisualizerExport;
  mesonFeatures.raspberry_pi = mapNull false withRaspberryPi;
  mesonFeatures.sample_processing = mapNull true withSampleProcessing;
  mesonFeatures.sample_resampling = mapNull true withSampleResampling;
  mesonFeatures.sample_resampling_mp = mapNull false withSampleResamplingMp;
  mesonFeatures.ssl = mapNull true withSsl;
  mesonOptions.executable_name_suffix = lib.concatStringsSep "-" (
    optionals mesonFeatures.output_portaudio [ "pa" ] ++
    optionals mesonFeatures.output_pulseaudio [ "pulse" ]
  );
in
assert mesonFeatures.codec_alac -> alac != null;
assert mesonFeatures.codec_faad2 -> faad2 != null;
assert mesonFeatures.codec_ffmpeg -> ffmpeg != null;
assert mesonFeatures.codec_flac -> flac != null;
assert mesonFeatures.codec_mad -> libmad != null;
assert mesonFeatures.codec_mpg123 -> mpg123 != null;
assert mesonFeatures.codec_opus -> opusfile != null;
assert mesonFeatures.codec_vorbis -> libvorbis != null;
assert mesonFeatures.control_infrared -> lirc != null;
assert mesonFeatures.output_alsa -> alsa-lib != null;
assert mesonFeatures.output_portaudio -> portaudio != null;
assert mesonFeatures.output_pulseaudio -> libpulseaudio != null;
assert mesonFeatures.sample_resampling -> mesonFeatures.sample_processing && soxr != null;
stdenv.mkDerivation {
  # the NixOS module uses the pname as the binary name
  pname = executableName;
  # versions are specified in `squeezelite.h`
  # see https://github.com/ralph-irving/squeezelite/issues/29
  version = lib.fileContents ../../../project_version.txt;

  inherit src;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ ] ++
    optionals mesonFeatures.codec_alac [ (getDev alac) ] ++
    optionals mesonFeatures.codec_faad2 [ (getDev faad2) ] ++
    optionals mesonFeatures.codec_ffmpeg [ (getDev ffmpeg) ] ++
    optionals mesonFeatures.codec_flac [ (getDev flac) ] ++
    optionals mesonFeatures.codec_mad [ (getDev libmad) ] ++
    optionals mesonFeatures.codec_mpg123 [ (getDev mpg123) ] ++
    optionals mesonFeatures.codec_opus [ (getDev opusfile) ] ++
    optionals mesonFeatures.codec_vorbis [ (getDev libvorbis) ] ++
    optionals mesonFeatures.control_infrared [ (getDev lirc) ] ++
    optionals mesonFeatures.output_alsa [ (getDev alsa-lib) ] ++
    optionals mesonFeatures.output_portaudio [ (getDev portaudio) ] ++
    optionals mesonFeatures.output_pulseaudio [ (getDev libpulseaudio) ] ++
    optionals mesonFeatures.sample_resampling [ (getDev soxr) ] ++
    optionals mesonFeatures.ssl [ (getDev openssl) ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace opus.c \
      --replace "<opusfile.h>" "<opus/opusfile.h>"
  '';

  mesonFlags = lib.mapAttrsToList lib.mesonOption mesonOptions ++
    lib.mapAttrsToList lib.mesonEnable mesonFeatures;

  # installPhase = ''
  #   runHook preInstall
  #
  #   install -Dm555 -t "$out"/bin -- squeezelite*
  #   install -Dm444 -t "$out"/share/doc/squeezelite -- *.txt *.md
  #
  #   runHook postInstall
  # '';

  meta = {
    description = "Lightweight headless squeezebox player for Logitech Media Server";
    homepage = "https://github.com/ralph-irving/squeezelite";
    license = let l = lib.licenses; in [ l.gpl3Plus ] ++ optionals mesonFeatures.codec_dsd [ l.bsd2 ];
    maintainers = let m = lib.maintainers; in [ m.adamcstephens m.bb010g ];
    platforms = lib.platforms.linux;
  };
}
