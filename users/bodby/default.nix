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
