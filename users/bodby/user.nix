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
        # inputs.ghostty.packages.${system}.default
        # vesktop
        webcord-vencord
        wl-clipboard
        alsa-utils
        grim
        slurp
        swaybg
        rofi-wayland
        waybar
        foot
        mpv
        imv
        imagemagick
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
    extraGroups = [
      "wheel"
      "audio"
      "video"
    ] ++ cfg.extraGroups;
  };
}
