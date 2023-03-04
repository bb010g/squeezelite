# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2003-2023 the Nixpkgs/NixOS contributors
{
  description = "Lightweight headless squeezebox player for Logitech Media Server";

  # inputs.allSystems.flake = false;
  # inputs.allSystems.follows = "flake-utils/allSystems";
  # inputs.defaultSystems.flake = false;
  # inputs.defaultSystems.follows = "flake-utils/defaultSystems";
  inputs.flake-compat.flake = false;
  inputs.flake-compat.url = "github:edolstra/flake-compat";
  # inputs.flake-utils.url = "github:bb010g/flake-utils/systems-inputs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.gitignore.inputs.nixpkgs.follows = "nixpkgs";
  inputs.gitignore.url = "github:hercules-ci/gitignore.nix";
  inputs.nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { ... } @ inputsInitial: let
    squeezeliteInitial = inputsInitial.self;
    nixpkgsLibInitial = inputsInitial.nixpkgs-lib.lib;
  in nixpkgsLibInitial.makeExtensible (squeezelite: let
    eachDefaultSystemMap = flakeUtils.eachDefaultSystemMap;
    flakeUtils = inputs.flake-utils.lib;
    inputs = squeezelite.inputs;
    instantiateNixpkgs = squeezeliteLib.instantiateNixpkgs;
    mapAttrs = nixpkgsLib.mapAttrs;
    nixpkgsLib = inputs.nixpkgs-lib.lib;
    squeezeliteLib = squeezeliteLibs.default;
    squeezeliteLibs = squeezelite.libs;
    system = flakeUtils.system;
  in {
    devShells = eachDefaultSystemMap (hostSystem: let
      nixpkgs = inputs.nixpkgs.legacyPackages.${hostSystem};
    in {
      default = nixpkgs.callPackage ({ lib, mkShell
      , reuse, squeezelite, squeezelite-pulse
      }: mkShell {
        inputsFrom = [
          squeezelite
          # squeezelite-pulse
        ];
        nativeBuildInputs = [
          (lib.getBin reuse)
        ];
      }) {
      };
    });
    inputs = builtins.removeAttrs inputsInitial [ "self" ] // {
      squeezelite = inputsInitial.self;
    };
    legacyPackages = eachDefaultSystemMap (hostSystem: {
      nixpkgs = squeezelite.nixpkgsInstantiations.${hostSystem};
    });
    libs = import ./nix/libs squeezelite;
    nixpkgsConfigs.default = {
    };
    nixpkgsInstantiations = eachDefaultSystemMap (hostSystem: {
      default = instantiateNixpkgs squeezelite { localSystem = hostSystem; };
    });
    nixpkgsInputs.default = inputs.nixpkgs;
    nixpkgsOverlays.default = import ./nix/nixpkgs-overlays/default.nix squeezelite;
    nixpkgsOverlays.imports = nixpkgsLib.composeManyExtensions [
    ];
    overlays = squeezelite.nixpkgsOverlays;
    packages = eachDefaultSystemMap (hostSystem: let
      legacyPackages = squeezelite.legacyPackages.${hostSystem};
      nixpkgs = legacyPackages.nixpkgs.default;
    in {
      alac = nixpkgs.alac;
      squeezelite = nixpkgs.squeezelite;
      squeezelite-pulse = nixpkgs.squeezelite-pulse;
    });
  });
}
# vim:ft=nix:et:sw=2:tw=0
