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
in with lib; {
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

        inputs.nvim.packages.${system}.default
      ]
      ++ optionals cfg.desktop.enable [
        wl-clipboard
        neovide
        # grim
        # slurp
        # swaybg
        mpv
        mpc
        imv
        # 'Medium' gives 'latexmk' for 'latexmk -pdf -pvc'/live changes in PDF.
        # texliveSmall
        brightnessctl
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
