{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.users.bodby.desktop;
  theme = import ./theme.nix { inherit pkgs; };
in {
  home-manager.users.bodby.programs.foot = {
    enable = cfg.enable;
    server.enable = false;

    settings = {
      mouse.hide-when-typing = true;

      main = {
        shell = "bash";
        # FIXME: Can I not separate font features with commas?
        # TODO: Also freeze these features so you can use them in browser and GTK.
        font = "${theme.fonts.monospace}:size=14:fontfeatures=${
          lib.strings.concatStringsSep ":fontfeatures=" [ "ss01" "ss02" ]
        }";
        underline-offset = 2;
        # TODO: Line height for Cascadia Code.
        line-height = "28px";
        font-size-adjustment = "1px";
        pad = "24x24 center";
      };

      cursor = {
        style = "block";
        unfocused-style = "none";
        color = "${theme.palette.base01} ${theme.palette.base15}";
      };

      colors = {
        # alpha = 0.85;
        foreground = theme.palette.base16;
        background = theme.palette.bg;

        regular0 = theme.palette.base01;
        regular1 = theme.palette.base02;
        regular2 = theme.palette.base03;
        regular3 = theme.palette.base04;
        regular4 = theme.palette.base05;
        regular5 = theme.palette.base06;
        regular6 = theme.palette.base07;
        regular7 = theme.palette.base08;
        bright0 = theme.palette.base09;
        bright1 = theme.palette.base10;
        bright2 = theme.palette.base11;
        bright3 = theme.palette.base12;
        bright4 = theme.palette.base13;
        bright5 = theme.palette.base14;
        bright6 = theme.palette.base15;
        bright7 = theme.palette.base16;

        selection-foreground = theme.palette.base16;
        selection-background = theme.palette.base01;
      };

      key-bindings = {
        scrollback-up-page = "none";
        scrollback-up-line = "none";
        scrollback-down-page = "none";
        scrollback-down-line = "none";
        scrollback-home = "none";
        primary-paste = "none";
        search-start = "none";
        spawn-terminal = "none";
        show-urls-launch = "none";
        prompt-prev = "none";
        prompt-next = "none";
        unicode-input = "none";

        scrollback-end = "Control+Shift+g";

        scrollback-up-half-page = "Control+Shift+u";
        scrollback-down-half-page = "Control+Shift+d";

        clipboard-copy = "Control+Shift+c XF86Copy";
        clipboard-paste = "Control+Shift+v XF86Paste";

        font-increase = "Control+Shift+equal";
        font-decrease = "Control+Shift+minus";
        font-reset = "Control+Shift+0";
      };

      mouse-bindings = {
        primary-paste = "none";
        font-increase = "none";
        font-decrease = "none";
      };

      tweak.font-monospace-warn = false;
      scrollback.indicator-position = "none";

      csd.preferred = "none";
    };
  };
}
