{ config, lib, pkgs, ... }:

with lib;

{

  options = {
    
    pkgs = mkOption {
      type = types.attrs;
      description = "Merged honixpot packages";
    };
    
  };

  config = {

    pkgs = pkgs // (import ../pkgs { inherit (pkgs) system; });

  };

}