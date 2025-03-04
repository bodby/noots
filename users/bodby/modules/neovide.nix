{
  pkgs,
  ...
}:
let
  theme = import ./theme.nix { inherit pkgs; };
in {
  home-manager.users.bodby.xdg.configFile."neovide/config.toml".source =
    (pkgs.formats.toml { }).generate "config.toml" {
      idle = true;
      tabs = false;
      fork = true;
      no-multigrid = false;

      font = {
        normal = [ "${theme.fonts.monospace}" ];
        size = 14;
        features."${theme.fonts.monospace}" = [ "+ss01" "+ss02" ];
      };
    };
}
