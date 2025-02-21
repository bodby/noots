{
  lib,
  pkgs,
  ...
}:
let
  theme = import ./theme.nix { inherit lib pkgs; };
in
{
  home-manager.users.bodby.xdg.configFile."neovide/config.toml".source =
    (pkgs.formats.toml { }).generate "config.toml" {
      idle = true;
      tabs = false;
      fork = true;
      no-multigrid = false;

      font = {
        normal = [ "${theme.fonts.monospace'}" ];
        size = 13.5;
        features."${theme.fonts.monospace'}" = [
          "+cv01"
          "+cv06"
          "+cv07"
          "+cv10"
          "+cv11"
          "+cv12"
        ];
      };
    };
}
