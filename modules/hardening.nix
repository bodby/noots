{ config, lib, ... }:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.hardening;
  mkDisableOption = name:
    lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable ${name}.";
      default = true;
      example = false;
    };
in {
  options = {
    modules.hardening = {
      enable = mkEnableOption "kernel hardening";
      kernel.enable = mkDisableOption "hardened kernel";

      multilib.enable = mkEnableOption "32-bit application support";
      bluetooth.enable = mkEnableOption "bluetooth";
    };
  };

  config = lib.mkIf cfg.enable {
    security = {
      lockKernelModules = true;
      protectKernelImage = true;
    };
  };
}
