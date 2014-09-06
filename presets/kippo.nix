{
  attacker = { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.openssh ];
    };
    
  kippo = {
    imports = [ ../modules ];
    honeypots.kippo.enable = true;
  };
}