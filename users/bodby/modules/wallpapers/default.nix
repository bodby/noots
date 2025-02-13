{
  config,
  lib,
  pkgs,
  ...
}:
let
  wallDir = "${config.home-manager.users.bodby.xdg.userDirs.pictures}/wallpapers";

  mkWallFiles =
    fileSet:
    lib.attrsets.mapAttrs' (filename: dir: rec {
      name = filename;
      value.source = dir;
      value.target = wallDir + "/" + name;
    }) fileSet;
in
{
  home-manager.users.bodby = {
    home.file = mkWallFiles {
      "eva1.png" = ./eva-unit-01-patrika-wall-alphacoders.png;
      "tlc.jpg" = ./emilis-baltrusaitis.jpg;
      "house.jpg" = ./rita-yuwei-li-witch-house.jpg;
      "castle.jpg" = ./andreas-rocha-castleonahill01.jpg;
      # Removed the signature on the bottom right. Sorry.
      # https://www.artstation.com/artwork/V2a955
      "lighthouse.png" = ./andreas-rocha-solitarylighthouseii-no-signature-sry.png;
    };

    systemd.user.services.swaybg = {
      Unit = {
        Description = "Wallpaper tool for Wayland compositors";
        Documentation = "https://github.com/swaywm/swaybg";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
      };

      Service = {
        ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i ${wallDir}/${
          config.modules.users.bodby.desktop.wallpaper
        }";

        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        KillMode = "mixed";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
