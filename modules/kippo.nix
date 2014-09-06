{ config, lib, ... }:

with lib;

let
  cfg = config.honeypots.kippo;

  configFile = with builtins; config.pkgs.writeText "kippo-config" ''
    [honeypot]
    ssh_addr = ${cfg.bindAddress}
    ssh_port = ${toString cfg.bindPort}
    hostname = ${cfg.hostname}
    log_path = ${cfg.logDir}
    download_path = ${cfg.stateDir}/dl
    filesystem_file = ${cfg.stateDir}/fs.pickle
    contents_path = ${cfg.stateDir}/honeyfs
    data_path = ${cfg.stateDir}/data
    txtcmds_path = ${cfg.textCommandsDir}
    ${optionalString (cfg.fakeAddress != null) "fake_addr = ${cfg.fakeAddress}"}
    ssh_version_string = ${cfg.sshVersionString}
    ${optionalString (cfg.bannerFile != null) "banner_file = ${cfg.bannerFile}"}
    public_key = ${cfg.stateDir}/public.key
    private_key = ${cfg.stateDir}/private.key
    
    ${cfg.extraConfig}
  '';

  runsh = config.pkgs.writeScript "kippo-run" ''
    ${kippo}/start.sh -l ${cfg.logDir}/twistd.log --pidfile /run/kippo/kippo.pid
  '';

in

{

  options.honeypots.kippo = {
    
    enable = mkOption {
      default = false;
      type = types.bool;
      description = "Whether to enable kippo honeypot service.";
    };

    bindAddress = mkOption {
      default = "0.0.0.0";
      type = types.str;
      description = "IP addresses to listen for incoming SSH connections.";
    };

    bindPort = mkOption {
      default = 2222;
      type = types.int;
      description = "Port to listen for incoming SSH connections.";
    };

    hostname = mkOption {
      default = "nas3";
      type = types.str;
      description = "Hostname for the honeypot. Displayed by the shell prompt of the virtual.";
    };

    stateDir = mkOption {
      default = "/var/lib/kippo";
      type = types.str;
      description = "Directory where to save the state of the honeypot.";
    };

    logDir = mkOption {
      default = "/var/log/kippo";
      type = types.str;
      description = "Directory where to write log files.";
    };

    downloadLimitSize = mkOption {
      default = 1000000;
      type = types.int;
      description = ''
        Maximum file size in bytes for downloaded files. A value of 0 means no limit.
        If the file size is known to be too big from the start, the file will not be
        stored on disk at all.
      '';
    };

    textCommandsDir = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = ''
        Directory for creating simple commands that only output text.
        If not provided, the default distributed with kippo will be used.
      '';

      apply = path: if path == null then "${config.pkgs.kippo}/txtcmds_path" else path;
    };

    fakeAddress = mkOption {
      default = null;
      type = types.nullOr types.str;
      description = ''
        Fake address displayed as the address of the incoming connection.
        This doesn't affect logging, and is only used by honeypot commands such as
        'w' and 'last'.
        If not specified, the actual IP address is displayed instead.
      '';
    };
    
    sshVersionString = mkOption {
      default = "SSH-2.0-OpenSSH_5.1p1 Debian-5";
      type = types.str;
      description = "Use this to disguise your honeypot from a simple SSH version scan.";
    };

    bannerFile = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = "Banner file to be displayed before the first login attempt.";
    };

    extraConfig = mkOption {
      default = "";
      type = types.lines;
      description = "Extra config for the honeypot.";
    };
    
  };

  config = mkIf cfg.enable {

    systemd.services.kippo = with config.pkgs; {
      wantedBy = [ "honeypots.target" ];
      environment.KIPPO_CONFIG = configFile;

      preStart = ''
        mkdir -m 0700 -p ${cfg.logDir}/tty ${cfg.stateDir} ${cfg.stateDir}/dl ${cfg.stateDir}/data /run/kippo

        if [ ! -f ${cfg.stateDir}/data/userdb.txt ]; then
          cp -v ${kippo}/data/userdb.txt ${cfg.stateDir}/data/userdb.txt
        fi
        
        if [ ! -f ${cfg.stateDir}/fs.pickle ]; then
          cp -v ${kippo}/fs.pickle ${cfg.stateDir}/fs.pickle
        fi

        if [ ! -d ${cfg.stateDir}/honeyfs ]; then
          cp -prv ${kippo}/honeyfs ${cfg.stateDir}/
        fi

        chown -R kippo ${cfg.stateDir} ${cfg.logDir} /run/kippo
        chmod -R u+w ${cfg.stateDir} ${cfg.logDir}
      '';
      
      serviceConfig = {
        User = "kippo";
        UMask = "0077";
        NoNewPrivileges = true;
        PermissionsStartOnly = true;
        ExecStart = "${kippo}/start.sh -l ${cfg.logDir}/twistd.log --pidfile /run/kippo/kippo.pid";
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.bindPort ];
    
    users.extraUsers = singleton
      { name = "kippo";
        uid = config.ids.uids.kippo;
        home = cfg.stateDir;
      };
    
  };
  
}