{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
let
  cfg = config.modules.users.bodby;
in
with lib;
{
  users.users.bodby = {
    packages =
      with pkgs;
      [
        file
        bc
        killall
        time
        iamb

        age
        sops

        inputs.nvim-btw.packages.${system}.default
      ]
      ++ optionals cfg.desktop.enable [
        wl-clipboard
        # grim
        # slurp
        # swaybg
        mpv
        imv
      ]
      ++ optionals cfg.gaming.enable [
        steam'
        prismlauncher
      ]
      ++ optionals cfg.creative.enable [
        # krita'
        blockbench
        # gimp'
      ];

    isNormalUser = true;
    createHome = true;
    homeMode = "700";
    extraGroups = [
      "wheel"
      "audio"
      "video"
    ];
  };
}
