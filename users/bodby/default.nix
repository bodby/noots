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

    extraGroups = mkOption {
      type = types.listOf types.str;
      description = "Extra groups the user is a part of";
      default = [ ];
    };

    # TODO: Functionality for all of these options.
    desktop = {
      enable = mkEnabledByDefault "desktop programs and fonts";
      hyprland = {
        animations.enable = mkEnabledByDefault "Hyprland animations";
        scale = mkOption {
          type = types.float;
          description = ''
            Scale used for fractional scaling.
            LibreWolf's 'DevPixelsPerPix' adds an extra 0.2 to this.
          '';
          default = 1.0;
        };

        sensitivity = mkOption {
          type = types.float;
          default = -0.2;
        };
      };

      waybar.cpuTemp = mkOptions {
        type = types.listOf types.path;
        default = [
          "/sys/devices/pci0000:00/0000:00:18.3/hwmon"
          "temp3_input"
        ];
      };

      hwmonPath = mkOption {
        type = types.str;
        description = "Absolute path to the CPU hwmon, used by Waybar";
        default = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
      };
      hwmonInputFile = mkOption {
        type = types.str;
        description = "Name of the input file inside 'hyprland.hwmonPath' read by Waybar, e.g. 'temp3_input'";
        default = "temp3_input";
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
