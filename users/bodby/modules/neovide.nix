{
  pkgs,
  ...
}:
{
  home-manager.users.bodby.xdg.configFile."neovide/config.toml".source = (pkgs.formats.toml { }).generate "config.toml" {
    idle = true;
    tabs = false;
    no-multigrid = true;

    font = {
      normal = [ "JetBrains Mono" ];
      size = 13.5;
      features."JetBrains Mono" = [ "cv06=1" ];
    };
  };
}
