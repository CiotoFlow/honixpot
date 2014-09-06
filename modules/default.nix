{
  
  networking.firewall.allowPing = true;

  config.systemd.targets.honeypots = {
    wantedBy = [ "multi-user.target" ];
  };

  imports = [
    ./honeypkgs.nix
    ./uids.nix
    ./kippo.nix
  ];

}