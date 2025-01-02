{
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.users.bodby.desktop;
in
{
  home-manager.users.bodby.programs.ghostty = {
    enable = cfg.enable;
    package = pkgs.ghostty';
    clearDefaultKeybinds = true;
    installBatSyntax = false;

    settings = {
      theme = "degraded";
      bold-is-bright = false;

      font-family = "JetBrains Mono";
      font-feature = "cv06";
      adjust-cell-height = "8%";
      font-size = 13.5;

      copy-on-select = false;
      keybind = [
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
        "ctrl+shift+plus=increase_font_size"
        "ctrl+shift+minus=decrease_font_size"
        "ctrl+shift+0=reset_font_size"
        "ctrl+l=clear_screen"
        "ctrl+g=scroll_to_top"
        "ctrl+shift+g=scroll_to_bottom"
        "ctrl+shift+u=scroll_page_up"
        "ctrl+shift+d=scroll_page_down"
        "ctrl+shift+k=scroll_to_prompt:-1"
        "ctrl+shift+j=scroll_to_prompt:+1"
      ];

      background-opacity = 0.9;
      # TODO: Does this stack with normal opacity?
      #       I don't even use the split windows.
      unfocused-split-opacity = 0.9;
      window-padding-x = 24;
      window-padding-y = 24;
      window-padding-balance = true;
      window-padding-color = "background";
      window-decoration = false;

      cursor-text = "#2b2b32";
      cursor-style = "block";
      cursor-style-blink = false;
      cursor-click-to-move = false;

      title = "Ghostty";
      auto-update = "off";
      confirm-close-surface = false;
      shell-integration = "bash";
      shell-integration-features = "no-cursor, no-title";
      gtk-single-instance = true;
      gtk-adwaita = false;
      resize-overlay = "never";
    };

    themes.degraded = {
      background = "#080808";
      foreground = "#d2d2df";
      cursor-color = "#9393a2";
      selection-foreground = "#d2d2df";
      selection-background = "#1e1e24";
      palette = [
        "0=#2b2b32"
        "1=#d16556"
        "2=#44ae6e"
        "3=#d79b48"
        "4=#7289fd"
        "5=#936df3"
        "6=#82cfff"
        "7=#9393a2"
        "8=#51505f"
        "9=#d16556"
        "10=#44ae6e"
        "11=#edb15b"
        "12=#8b9efd"
        "13=#b294ff"
        "14=#82cfff"
        "15=#d2d2df"
      ];
    };
  };
}
