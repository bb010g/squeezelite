# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2003-2023 the Nixpkgs/NixOS contributors
squeezelite:
pkgsFinal: pkgsPrev: let
  gitignore = squeezelite.inputs.gitignore.overlay pkgsFinal pkgsPrev;
  squeezeliteSrc = gitignore.gitignoreSource ../..;
in {
  squeezelite = pkgsFinal.callPackage ../nixpkgs-pkgs/squeezelite {
    audioBackend = "alsa";
    src = squeezeliteSrc;
  };

  squeezelite-pulse = pkgsFinal.callPackage ../nixpkgs-pkgs/squeezelite {
    audioBackend = "pulse";
    src = squeezeliteSrc;
  };
}
