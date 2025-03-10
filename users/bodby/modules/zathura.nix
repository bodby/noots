{
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.users.bodby.desktop;
  theme = import ./theme.nix pkgs;
in
{
  home-manager.users.bodby.programs.zathura = {
    enable = cfg.enable;
    package = pkgs.zathura';
    options = {
      recolor = true;
      font = "${theme.fonts.monospace} normal 13.5";
      recolor-lightcolor = "rgba(0,0,0,0.0)";
      recolor-darkcolor = "#${theme.palette.base16}";
      default-bg = "#${theme.palette.bg}";
      inputbar-bg = "#${theme.palette.bgDark}";
      notification-bg = "#${theme.palette.bgDark}";
      notification-fg = "#${theme.palette.base16}";
      notification-error-bg = "#${theme.palette.bgDark}";
      notification-error-fg = "#${theme.palette.base10}";
      notification-warning-bg = "#${theme.palette.bgDark}";
      notification-warning-fg = "#${theme.palette.base12}";
      inputbar-fg = "#${theme.palette.base16}";
      guioptions = "none";
      highlight-color = "rgba(255,255,255,0.07)";
      highlight-active-color = "rgba(255,255,255,0.2)";
      highlight-fg = "#${theme.palette.base16}";
      incremental-search = true;
      database = "null";
    };
  };
}
