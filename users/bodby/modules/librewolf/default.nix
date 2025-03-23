{
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.users.bodby.desktop;
in
{
  home-manager.users.bodby.programs.librewolf = {
    enable = cfg.enable;
    package = pkgs.librewolf';

    profiles.bodby = {
      isDefault = true;
      # TODO: Add settings for extensions if possible.
      extensions.packages = with pkgs.firefox-addons; [
        vimium-ff
        ublock-origin
        # tridactyl
      ];

      # FIXME: Actually work on this because everything is unreadable right now.
      # userContent = builtins.readFile ./userContent.css;
      # userChrome = builtins.readFile ./userChrome.css;

      search.default = "ddg";
      search.force = true;

      settings = {
        "layout.css.devPixelsPerPx" = cfg.hyprland.browserScale;
        "browser.tabs.allow_transparent_browser" = true;
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "browser.theme.content-theme" = 0;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        "webgl.disabled" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.downloads" = false;
        "privacy.resistFingerprinting" = true;

        "middlemouse.paste" = false;
        "general.autoScroll" = true;
      };
    };

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "newtab";
      DisplayMenuBar = "default-off";
      SearchBar = "separate";

      Cookies.Allow = [
        "https://github.com"
        "https://discord.com"
        "https://design.penpot.app"
        "https://codeberg.org"
        "https://mail.proton.me"
        "https://account.proton.me"
      ];
    };
  };
}
