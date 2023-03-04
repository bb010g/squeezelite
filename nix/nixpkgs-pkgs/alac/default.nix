# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2003-2023 the Nixpkgs/NixOS contributors
{ fetchFromGitHub, lib, stdenv
, autoreconfHook, pkg-config, validatePkgConfig
}:

stdenv.mkDerivation {
  pname = "alac";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "mikebrady";
    repo = "alac";
    rev = "0.0.7";
    hash = "sha256-26vepIv9uBt3IR5tGc344MHhyYrB/sIm1pIzX7ojORI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    validatePkgConfig
  ];

  outputs = [ "dev" "out" ];

  meta = {
    description = "Apple Lossless Codec and Utility";
    homepage = "https://github.com/mikebrady/alac";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.bb010g ];
    platforms = lib.platforms.all;
  };
}
