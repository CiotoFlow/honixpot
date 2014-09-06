{ system ? builtins.currentSystem, name ? "unnamed", cluster }:

let
  testing = import <nixos/lib/testing.nix> { inherit system; };
in
  (testing.makeTest { testScript = ""; inherit name; nodes = import cluster; }).driver