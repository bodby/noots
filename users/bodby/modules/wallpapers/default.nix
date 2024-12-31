{
  config,
  lib,
  ...
}:
let
  wallDir = "${config.home-manager.users.bodby.xdg.userDirs.pictures}/wallpapers/";

  mkWallFiles =
    fileSet:
    lib.attrsets.mapAttrs' (filename: dir: rec {
      name = filename;
      value.source = dir;
      value.target = wallDir + name;
    }) fileSet;
in
{
  # home-manager.users.bodby.file = mkWallFiles {
  #   "eva1.png" = ./eva-unit-01-patrika-wall-alphacoders.png;
  #   "tlc.jpg" = ./emilis-baltrusaitis.jpg;
  #   "house.jpg" = ./rita-yuwei-li-witch-house.jpg;
  # };
}
