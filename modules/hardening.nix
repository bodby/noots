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
      description = "Whether to enable " + desc;
      default = true;
    };
in
with lib;
{
  options.modules.hardening = {
    # NOTE: You do have to manually change your kernel to a hardened one.
    enable = mkEnableOption "hardened kernel params";

    bluetooth.enable = mkEnableOption "bluetooth support";
    # TODO: vvv
    scudo.enable = mkEnableOption "hardened memory allocator";
    nas.enable = mkEnabledByDefault "network filesystems for NAS";
    panicOnOops = mkEnableOption "kernel panics on oops";
    moduleSignatures.enable = mkEnableOption "checking kernel module signatures";
    fileSystems.enable = mkEnabledByDefault "hardened mount options";
  };

  config = mkIf cfg.enable { };
}
