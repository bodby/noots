{
  config,
  lib,
  ...
}:
let
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
  imports = [
    ./user.nix
    ./home.nix
  ];

  options.modules.users.bodby = {
    gaming.enable = mkEnableOption "gaming software";
    creative.enable = mkEnableOption "creative software and drivers";

    desktop = {
      enable = mkEnabledByDefault "desktop programs and fonts";
      hyprland = {
        scale = mkOption {
          type = types.float;
          description = "Fractional scaling amount";
          default = 1.0;
        };

        browserScale = mkOption {
          type = types.float;
          description = "LibreWolf's 'DevPixelsPerPix'";
          default = 1.0;
        };

        sensitivity = mkOption {
          type = types.float;
          default = -0.2;
        };
      };

      waybar.cpuTemp = mkOption {
        type = types.path;
        description = "Absolute path to the hwmon CPU temp file";
        default = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon2/temp3_input";
      };
    };
  };

  config =
    let
      cfg = config.modules.users.bodby;
    in
    {
      hardware.graphics = mkIf cfg.gaming.enable {
        enable = true;
        enable32Bit = true;
      };

      services.xserver.wacom.enable = mkIf cfg.creative.enable true;
    };
}
