{
  pkgs,
  ...
}:
{
  home-manager.users.bodby.xdg.configFile."neovide/config.toml".source =
    (pkgs.formats.toml { }).generate "config.toml" {
      idle = true;
      tabs = false;
      fork = true;
      no-multigrid = false;

      font = {
        normal = [ "JetBrains Mono" ];
        size = 13.5;
        features."JetBrains Mono" = [
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
