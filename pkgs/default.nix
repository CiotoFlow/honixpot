{ system ? builtins.currentSystem }:

let
  nixpkgs = import <nixpkgs> { inherit system; };
  callPackage = nixpkgs.newScope honeyPkgs;
  honeyPkgs = {
# not indented on purpose

kippo = callPackage ./kippo { };

  };
in honeyPkgs
