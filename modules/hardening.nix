{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.hardening;
  mkEnabledByDefault =
    desc:
    lib.mkOption {
      type = lib.types.bool;
      description = "Whether to " + desc;
      default = true;
    };
in
with lib;
{
  options.modules.hardening = {
    # NOTE: You do have to manually change your kernel to a hardened one.
    enable = mkEnableOption "hardened kernel params";

    multilib.enable = mkEnableOption "32-bit support";
    bluetooth.enable = mkEnableOption "bluetooth";
    userns.enable = mkEnabledByDefault "enable unprivileged user namespaces";

    fileSystems = {
      networkStorage.enable = mkEnableOption "NAS filesystems";
      noExecHome = mkEnabledByDefault "disable executables in home dirs";
      restrictHomePerms = mkEnabledByDefault "set 0700 perms for home dirs and files";
    };

    memory.swappiness = mkOption {
      type = types.int;
      description = ''
        How readily memory should be copied to swap.
        Lower values mean a lesser likelyhood
      '';
      default = 10;
    };
  };

  config = mkIf cfg.enable { };
}
