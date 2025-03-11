{ config, lib, ... }:
let
  cfg = config.modules;
in {
  imports = [
    ./hardening.nix
  ];

  options = {
    modules.coreDumps.enable = lib.mkEnableOption "core dumps";
  };

  config = {
    security = {
      sudo = {
        enable = true;
        execWheelOnly = true;

        extraConfig = ''
          Defaults lecture=never
          Defaults passprompt="Enter passphrase for user '%p': "
        '';
      };
    };

    systemd = {
      coredump = {
        enable = cfg.coreDumps.enable;
        extraConfig = lib.optionalString (!cfg.coreDumps.enable) ''
          Storage=none
        '';
      };
    };
  };
}
