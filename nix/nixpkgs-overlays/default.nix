# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2003-2023 the Nixpkgs/NixOS contributors
squeezelite:
pkgsFinal: pkgsPrev: let
  gitignore = squeezelite.inputs.gitignore.overlay pkgsFinal pkgsPrev;
in {
  alac = pkgsFinal.callPackage ../nixpkgs-pkgs/alac { };

  squeezelite = pkgsFinal.callPackage ../nixpkgs-pkgs/squeezelite {
    withOutputAlsa = true;
    src = gitignore.gitignoreSource ../..;
  };

  squeezelite-pulse = pkgsFinal.squeezelite.override (argsPrev: {
    withOutputAlsa = false;
    withOutputPulseaudio = true;
  });
}
