{ system ? builtins.currentSystem }:

let
  nixpkgs = import <nixpkgs> { inherit system; };
  callPackage = nixpkgs.newScope honeyPkgs;
  honeyPkgs = {
# not indented on purpose

kippo = callPackage ./kippo { };

php-bfr = callPackage ./php-bfr { };

glastopf = callPackage ./glastopf { };

pylibinjection = callPackage ./pylibinjection { };

libtaxii = callPackage ./libtaxii { };

hpfeeds = callPackage ./hpfeeds { };

  };
in honeyPkgs
