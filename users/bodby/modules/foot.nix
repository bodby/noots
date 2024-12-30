{
  home-manager.users.bodby.programs.foot = {
    enable = true;
    server.enable = false;
    settings = {
      mouse.hide-when-typing = true;

      main = {
        shell = "bash";
        font = "JetBrains Mono:size=13.5:fontfeatures=cv06";
        line-height = 20;
        font-size-adjustment = 1;
        pad = "24x24 center";
      };

      cursor = {
        style = "block";
        unfocused-style = "none";
        color = "2b2b32 9393a2";
      };

      colors = {
        alpha = 0.9;
        foreground = "d2d2dc";
        background = "080808";

        regular0 = "2b2b32";
        regular1 = "d16556";
        regular2 = "44ae6e";
        regular3 = "d79b48";
        regular4 = "7289fd";
        regular5 = "936df3";
        regular6 = "82cfff";
        regular7 = "9393a2";

        bright0 = "51505f";
        bright1 = "d16556";
        bright2 = "44ae6e";
        bright3 = "edb15b";
        bright4 = "8b9efd";
        bright5 = "b294ff";
        bright6 = "82cfff";
        bright7 = "d2d2dc";

        selection-foreground = "d2d2dc";
        selection-background = "2b2b32";
      };

      key-bindings = {
        scrollback-up-page = null;
        scrollback-up-line = null;
        scrollback-down-page = null;
        scrollback-down-line = null;
        scrollback-home = null;
        primary-paste = null;
        search-start = null;
        spawn-terminal = null;
        show-urls-launch = null;
        prompt-prev = null;
        prompt-next = null;
        unicode-input = null;

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
        primary-paste = null;
        font-increase = null;
        font-decrease = null;
      };

      tweak.font-monospace-warn = false;
      scrollback.indicator-position = null;
    };
  };
}
