# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2003-2023 the Nixpkgs/NixOS contributors
{ ... } @ squeezelite: let
  inherit (builtins)
    mapAttrs
    removeAttrs
  ;
  inherit (nixpkgsLib)
    makeExtensible
  ;
  nixpkgsLib = squeezelite.inputs.nixpkgs-lib.lib;
  squeezeliteLibs = squeezelite.libs;
in mapAttrs (name: makeExtensible) {
  default = squeezeliteLib: {
    instantiateNixpkgs = self: let
      nixpkgsConfigs = self.nixpkgsConfigs or { };
      nixpkgsOverlays = self.nixpkgsOverlays or { };
      nixpkgsInputs = self.nixpkgsInputs or {
        default = self.inputs.nixpkgs;
      };
      defaultNixpkgsInput = nixpkgsInputs.default;
      defaultNixpkgsConfig = nixpkgsConfigs.default or { };
      defaultNixpkgsOverlays = if nixpkgsOverlays ? imports then
        if nixpkgsOverlays ? default then [
          nixpkgsOverlays.imports
          nixpkgsOverlays.default
        ] else [ ]
      else if nixpkgsOverlays ? default then [
        nixpkgsOverlays.default
      ] else [ ];
    in args: let
      nixpkgsInput = args.input or defaultNixpkgsInput;
    in import nixpkgsInput (removeAttrs args [ "input" ] // {
      localSystem = args.localSystem;
      crossSystem = args.crossSystem or null;
      config = if args ? config
        then defaultNixpkgsConfig // args.config
        else defaultNixpkgsConfig;
      overlays = if args ? overlays
        then defaultNixpkgsOverlays ++ args.overlays
        else defaultNixpkgsOverlays;
    });
  };
}
