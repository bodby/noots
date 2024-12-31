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
    };

    systemd.user.services.swaybg = {
      Unit = {
        Description = "Wallpaper tool for Wayland compositors";
        Documentation = "https://github.com/swaywm/swaybg";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
      };

      Service = {
        ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i ${wallDir}/house.jpg";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        KillMode = "mixed";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
