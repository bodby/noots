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
    desktop.enable = mkEnabledByDefault "desktop programs and fonts";
    gaming.enable = mkEnableOption "gaming software";
    creative.enable = mkEnableOption "creative software and drivers";

    extraGroups = mkOption {
      type = types.listOf types.str;
      description = "Extra groups the user is a part of";
      default = [ ];
    };

    # TODO: Functionality for all of these options.
    desktop = {
      animations.enable = mkEnabledByDefault "Hyprland animations";

      libreWolfScaleFactor = mkOption {
        type = types.str;
        description = "LibreWolf's 'DevPixelsPerPix'";
        default = "1.125";
      };
      sensitivity = mkOption {
        type = types.float;
        default = -0.2;
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
