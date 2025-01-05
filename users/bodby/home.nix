{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
let
  cfg = config.modules.users.bodby;
  # sopsSecrets = config.home-manager.users.bodby.sops.secrets;
in
{
  imports = [ ./modules ];

  home-manager.users.bodby = {
    sops = {
      age = {
        keyFile = "/home/bodby/.config/sops/age/keys.txt";
        sshKeyPaths = [ "/home/bodby/.ssh/id_ed25519" ];
        generateKey = true;
      };

      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";

      # Will move everything to sops once I actually need it.
      # secrets.git_signature = { };
    };

    # TODO: This is ugly; I need to move this elsewhere.
    xdg.configFile."git/signers".text = ''
      bodby@sentinel ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMzyc5JE0+ZHPBUba1lEw0crucPcy4reXwod1hyWTUf+ baraa.homsi@proton.me
      bodby@scout ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/l3GyPRNDoC1J0yJS00UXj1qhiTvuqChzBgmOhB4mO baraa.homsi@proton.me
    '';

    programs = {
      home-manager.enable = true;

      git = {
        enable = true;
        userName = "Baraa Homsi";
        userEmail = "baraa.homsi@proton.me";
        extraConfig = {
          init.defaultBranch = "master";

          gpg.format = "ssh";
          # TODO: Change this too along with 'xdg.configFile."git/signers"'.
          gpg.ssh.allowedSignersFile = "/home/bodby/.config/git/signers";
          user.signingKey = "/home/bodby/.ssh/id_ed25519.pub"; # sopsSecrets.git_signature.path
          commit.gpgsign = false;
          merge.verifySignatures = true;

          core.symlinks = false;
          transfer.fsckobjects = true;
          fetch.fsckobjects = true;
          receive.fsckobjects = true;

          url = {
            "git@github.com:".insteadOf = [
              "github:"
              "https://github.com/"
            ];

            "https://gitlab.com/".insteadOf = "gitlab:";
          };
        };
      };

      # Funny. I only have one SSH key. This is useless.
      # https://github.com/FiloSottile/whoami.filippo.io
      ssh.matchBlocks = {
        "github.com" = lib.hm.dag.entryBefore [ "*" ] {
          extraOptions.PubkeyAuthentication = true;
          identityFile = "/home/bodby/.ssh/id_ed25519";
        };

        "*" = {
          extraOptions.PubkeyAuthentication = false;
          identitiesOnly = true;
        };
      };

      librewolf = {
        enable = cfg.desktop.enable;
        package = pkgs.librewolf';

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
          # "unified" (URL and search in same bar) or "separate".
          SearchBar = "separate";

          Cookies.Allow = [
            "https://github.com"
            "https://discord.com"
            "https://design.penpot.app"
          ];

          # This doesn't work. It doesn't automatically install Vimium.
          # ExtensionSettings = {
          #   "*" = {
          #     installation_mode = "blocked";
          #     blocked_install_message = "Noooooo! My purity!";
          #   };
          #
          #   "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          #     # install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
          #     installation_mode = "force_installed";
          #   };
          # };
        };

        # TODO: Custom CSS in separate file and also move LibreWolf to modules/.
        #       Also, I need to make the theme actually look good; I haven't touched it and just
        #       copied it from the url in 'userContent'.
        profiles.bodby = {
          isDefault = true;
          extensions = with inputs.nur.legacyPackages.${system}.repos.rycee.firefox-addons; [
            ublock-origin
            vimium
          ];

          userContent = ''
            /* https://www.reddit.com/r/unixporn/comments/1e10wwp/hyprland_too_much_blur/ */

            /***********************************************************/
            /*
            /* NOTE: Firefox Native Sites
            /*
            /***********************************************************/
            @-moz-document url-prefix() {
              :root {
                --newtab-background-color: transparent !important;
                --newtab-background-color-secondary: transparent !important;
              }
            }

            @-moz-document url-prefix(about:preferences) {
              :root {
                --in-content-page-background: transparent !important;
                --in-content-box-background: transparent !important;
              }
            }

            @-moz-document url-prefix(about:addons) {
              :root {
                --in-content-page-background: transparent !important;
              }
            }

            @-moz-document url-prefix(about:support) {
              :root {
                --in-content-page-background: transparent !important;
                --in-content-table-background: transparent !important;
                --in-content-table-header-background: transparent !important;
                /*--in-content-table-header-background: rgba(0, 221, 225, 0.3) !important;*/

              }
            }

            @-moz-document url-prefix(about:config) {
              :root {
                --in-content-page-background: transparent !important;
                --in-content-box-background: transparent !important;
              }
            }

            /* @-moz-document url-prefix(about:home), */
            /* url-prefix(about:newtab), */
            /* url-prefix(about:config), */
            /* url-prefix(about:addons), */
            /* url-prefix(about:support), */
            /* { */
            /* :root { */
            /*   --in-content-page-background: transparent !important; */
            /* } */
            /**/
            /* #toolbar { */
            /*   background-color: transparent !important; */
            /* } */
            /**/
            /* .main-search { */
            /*   background: transparent !important; */
            /* } */
            /**/
            /* .main-heading { */
            /*   background: transparent !important; */
            /* } */
            /**/
            /**/
            /* #about-config-search { */
            /*   background: transparent !important; */
            /* } */
            /**/
            /* #prefs { */
            /*   background-color: transparent !important; */
            /* } */
            /* } */

            /***********************************************************/
            /*
            /* NOTE: YouTube
            /*
            /***********************************************************/
            @-moz-document domain("youtube.com") {

              /* :root { */
              /*   background-color: transparent !important; */
              /* } */
              html,
                ytd-app,
                ytd-mini-guide-renderer {
                  background-color: transparent !important;
                }

              ytd-mini-guide-entry-renderer {
                background-color: transparent !important;
  border: 1px solid rgba(160, 160, 171, 0.3) !important;
              }

              ytd-playlist-panel-renderer {
                --yt-lightsource-section2-color: transparent !important;
              }

              div.header.style-scope.ytd-playlist-panel-renderer {
  background: transparent !important;
              }

              .playlist-items.ytd-playlist-panel-renderer {
                background-color: transparent !important;
              }

              #items.ytd-mini-guide-renderer {
              gap: 2rem !important;
              }

              a.ytd-mini-guide-entry-renderer {
              padding: 8px 0 7px !important;
              }

              #background.ytd-masthead {
                background-color: transparent !important;
              }

              #header {
              display: none !important;
              }

              #container.ytd-searchbox {
                background-color: transparent !important;
                border-color: rgba(160, 160, 171, 0.3) !important;
              }

              .button-container.ytd-rich-shelf-renderer {
                background-color: transparent !important;
              }
              }

              /*TAILWIND DOCS*/
              @-moz-document domain("tailwindcss.com") {
                .dark\:bg-slate-900:is(.dark *) {
                  background-color: transparent !important;
                }
              }

              /*GITHUB*/
              @-moz-document domain("github.com") {
                :root {
                  --bgColor-default: transparent !important;
                  --bgColor-inset: transparent !important;
                  --bgColor-muted: rgba(160, 160, 171, 0.3) !important;
                  --borderColor-default: rgba(160, 160, 171, 0.3) !important;
                  --borderColor-muted: rgba(160, 160, 171, 0.3) !important;
                }

                .color-bg-subtle {
                  background-color: transparent !important;
                }

                .input-contrast {
                  background-color: transparent !important;
                }
              }

              /* GOOGLE */
              @-moz-document domain("google.com") {

                body {
              background: transparent !important;
                }

                .MV3Tnb,
                  .gb_x,
                  .FPdoLc.lJ9FBc,
                  .o3j99.qarstb,
                  .o3j99.c93Gbe,
                  .Lu57id,
                  .lJ9FBc,
                  .YR2tRd,
                  .QViVQe,
                  .s2agxb.mWcf0e,
              #sfooter {
                display: none !important;
              }

              #gb,
              .CvDJxb,
                .appbar,
                .MjjYud,
                .hlcw0c,
                .dG2XIf,
                .YbqTTb {
                  background-color: transparent !important;

                }


              .RNNXgb,
                .cF4V5c {
                  background-color: rgba(255, 255, 255, 0.1) !important;
                  backdrop-filter: blur(10px) !important;
              border: none !important;
                }

              .xtSCL {
              border: none !important;
                      box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1) !important;
              }



              .aajZCb {
              background: rgba(255, 255, 255, 0.1) !important;
                          backdrop-filter: blur(10px) !important;
                          box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1) !important;
              }



              .ZFiwCf,
                .kLhEKe,
                .p8Jhnd,
                .S8ee5 {
                  background-color: transparent !important;

                }

              .b2Rnsc {
                background-color: transparent !important;
              border: 1px solid rgba(161, 161, 170, 0.1);
              }


              .GKS7s,
                .Ww4FFb {
                  background-color: transparent !important;
              border: 1px solid rgba(161, 161, 170, 0.1);
                }

              g-inner-card {
                background-color: transparent !important;
              border: 1px solid rgba(161, 161, 170, 0.1);
              }

              .REySof,
                .NQyKp.h4wEae {
                  background-color: transparent !important;
                }

              .NQyKp.Hyaw8c.h4wEae.Maj6Tc {
                border-color: rgba(161, 161, 170, 0.2) !important;
              }

              .UivI7b {
              background: transparent !important;
              border: 1px solid rgba(161, 161, 170, 0.2) !important;
                      box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1) !important;
              }

              .akqY6 {
                background-color: rgba(161, 161, 170, 0.2) !important;
              border: 1px solid rgba(161, 161, 170, 0.2) !important;
                      box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1) !important;
              }

              .zLSRge,
                .Hwkikb.WY0eLb {
                  /*border: 1px solid rgba(161, 161, 170, 0.2) !important;*/
                  border-color: rgba(161, 161, 170, 0.2) !important;

                }

              .wdQNof {
                border-color: rgba(161, 161, 170, 0.1) !important;
              }

              .gYJ4of.famfbb {
                background-color: transparent !important;
              border: 1px solid rgba(161, 161, 170, 0.1) !important;
              }

              g-fab {
                background-color: rgba(161, 161, 170, 0.1) !important;
              }

              .GCSyeb {
                background-color: rgba(161, 161, 170, 0.1) !important;
              }

              .aUSklf {
                border-top: rgba(161, 161, 170, 0.1) !important;
                border-width: 2px;
              }

              .GOE2if,
                .ez8jFf,
                .MsCHpb,
                .iRPzcb,
                hr {
                  border-color: rgba(161, 161, 170, 0.3) !important;
                }

              .ttwCMe {
                background-color: transparent !important;
              }

              #rhs.u7yw9 {
                border-color: rgba(161, 161, 170, 0.3);
              }

              .qe1Dgc {
                background-color: transparent !important;
              }

              .uais2d {
                background-color: rgba(161, 161, 170, 0.3) !important;
              }

              .I6TXqe {
                background-color: transparent !important;
              }

              .TQc1id .I6TXqe {
              border: 1px solid rgba(161, 161, 170, 0.3) !important;
              }

              .sfbg {
                background-color: transparent !important;
              }

              .wH6SXe {
                background-color: transparent !important;
              }

              .BA0zte,
                .bqW4cb {
                  border-color: rgba(161, 161, 170, 0.3) !important;
                }

              .JJZKK.Wui1sd {
                border-color: rgba(161, 161, 170, 0.3) !important;
              }

              .ab_button {
                background-color: rgba(161, 161, 170, 0.2) !important;
                border-radius: 10px !important;
                border-color: transparent !important;
              transition: background-color 0.2s ease-in !important;
              }

              .ab_button:hover {
                background-color: rgba(161, 161, 170, 0.1) !important;
              }

              .WxVj2b {
              background: rgba(161, 161, 170, 0.3) !important;
              }

              .RzdJxc {
                border-color: rgba(161, 161, 170, 0.3) !important;
              }

              .rKnmn {
                border-color: rgba(161, 161, 170, 0.3) !important;
              }

              .Bi9oQd {
                background-color: rgba(161, 161, 170, 0.3) !important;
              }

              .JiJthb,
                .JiJthb .GKS7s:not([selected]) {
                  background-color: transparent !important;
                  backdrop-filter: blur(10px) !important;
                }

              .JiJthb .F9Idpe.Iy1nvd,
                .F9Idpe {
              background: transparent !important;
                }

              .KLEmSd,
                .GKS7s {
                  border-color: rgba(160, 160, 171, 0.3) !important;
                }
              }


              /***********************************************************/
              /*
              /* NOTE: Github
              /*
              /***********************************************************/
              @-moz-document domain("github.com") {
                :root {
                  --bgColor-default: transparent !important;
                  --bgColor-inset: transparent !important;
                  --bgColor-muted: rgba(160, 160, 171, 0.3) !important;
                  --borderColor-default: rgba(160, 160, 171, 0.3) !important;
                  --borderColor-muted: rgba(160, 160, 171, 0.3) !important;
                }

                .color-bg-subtle {
                  background-color: transparent !important;
                }

                .input-contrast {
                  background-color: transparent !important;
                }

                .js-snippet-clipboard-copy-unpositioned .markdown-body .snippet-clipboard-content,
                  .js-snippet-clipboard-copy-unpositioned .markdown-body .highlight {
                    background-color: transparent !important;
                  }

                .markdown-body .highlight pre,
                  .markdown-body pre {
                    background-color: rgba(34, 21, 81, 0.6) !important;
                  }
              }


              /***********************************************************/
              /*
              /* NOTE: Reddit
              /*
              /***********************************************************/
              @-moz-document domain("reddit.com") {
                * {
                  --color-neutral-background: transparent !important;
                  --color-neutral-background-weak: transparent !important;
                  --color-neutral-background: transparent !important;
                  --color-neutral-background-selected: rgba(160, 160, 171, 0.3) !important;
                  --color-secondary-background: rgba(160, 160, 171, 0.3) !important;
                  --color-neutral-background-weak: transparent !important;
                  --color-button-secondary-background: transparent !important;
                  --color-neutral-background: transparent !important;
                  --shreddit-content-background: transparent !important;
                  --color-neutral-background-hover: rgba(160, 160, 171, 0.3) !important;
                  --color-tone-5: rgba(26, 255, 255, 0.3) !important;
                }

                blockquote {
                  border-color: rgba(26, 255, 255, 0.3);
                }

                .\[\&\>\.threadline\>\*\]\:border-tone-4>.threadline>* {
                  border-color: rgba(160, 160, 171, 0.3) !important;
                }

                .bg-\[color\:var\(--shreddit-content-background\)\] {
                  background-color: transparent !important;
                }

                .bg-tone-4 {
                  background-color: rgba(160, 160, 171, 0.3) !important;
                }

              #comment-tree {
                background-color: transparent !important;
              }

              :root.theme-dark .sidebar-grid,
                :root.theme-dark .grid-container.grid,
                :root.theme-dark .sidebar-grid .theme-beta:not(.stickied):not(#left-sidebar-container):not(.left-sidebar-container),
                :root.theme-dark .sidebar-grid .theme-rpl:not(.stickied):not(#left-sidebar-container):not(.left-sidebar-container),
                :root.theme-dark .grid-container.grid .theme-beta:not(.stickied):not(#left-sidebar-container):not(.left-sidebar-container),
                :root.theme-dark .grid-container.grid .theme-rpl:not(.stickied):not(#left-sidebar-container):not(.left-sidebar-container) {
                  background-color: transparent !important;
                }

              html {
                background-color: transparent !important;
              }

              .bg-neutral-background {
                background-color: transparent !important;
              }

              .bg-neutral-background-selected {
                background-color: rgba(160, 160, 171, 0.2) !important;
              }

              .bg-neutral-background-hover {
                background-color: rgba(160, 160, 171, 0.2) !important;
              }

              .bg-secondary-background {
                background-color: rgba(160, 160, 171, 0.2) !important;
              }

              .bg-neutral-background-weak {
                background-color: transparent !important;
              }

              .button-secondary {
                background-color: transparent !important;
              }

              }

              /***********************************************************/
              /*
              /* NOTE: Wikipedia
              /*
              /***********************************************************/
              @-moz-document domain("wikipedia.org") {
                @layer {

                  html,
                    body {
                      background-color: transparent !important;
                    }
                }

                hr {
              display: none !important;
                }

                .pure-form input[type="search"] {
                  background-color: transparent !important;
                  border-color: rgba(160, 160, 171, 0.2) !important;
                  border-radius: 10px 0 0 10px !important;
                  box-shadow: none !important;
                }

                .pure-button-primary-progressive {
                  background-color: transparent !important;
                  border-color: rgba(160, 160, 171, 0.2) !important;
                  border-radius: 0 10px 10px 0 !important;
                }

                .lang-list-border {
                  background-color: transparent !important;
                }

                .lang-list-button-wrapper {
              display: none !important;
                }

                .footer {
              display: none !important;
                }
              }


              /***********************************************************/
              /*
              /* NOTE: Hyprland wiki
              /*
              /***********************************************************/
              @-moz-document domain("hyprland.org") {
                :is(html[class~="dark"] body) {
                  background-color: transparent !important;
                }

                :is(html[class~="dark"] .dark\:bg-neutral-800) {
                  background-color: transparent !important;
              border: 1px solid rgba(160, 160, 171, 0.3) !important;
                }
              }

              /***********************************************************/
              /*
              /* NOTE: Nix Pkgs
              /*
              /***********************************************************/
              @-moz-document domain("nixos.org") {
                body {
              background: transparent !important;
                }

                .navbar.navbar.navbar.navbar.navbar.navbar>.navbar-inner {
                  background-color: rgba(100, 100, 100, 0.1) !important;
                  backdrop-filter: blur(10px) !important;
                }

                .navbar.navbar.navbar.navbar.navbar.navbar>.navbar-inner li>a {
              background: rgba(160, 160, 171, 0.2) !important;
              transition: all 0.2s ease-in !important;
                }

                .navbar.navbar.navbar.navbar.navbar.navbar>.navbar-inner li>a:hover {
              background: rgba(160, 160, 171, 0.1) !important;
                }

                .search-input>div:first-child:first-child:first-child input {
              background: transparent !important;
              border: 1px solid rgba(160, 160, 171, 0.3) !important;
                }

                .search-input>div>button {
              background: transparent !important;
              border: 1px solid rgba(160, 160, 171, 0.3) !important;
              transition: all 0.2s ease-in !important;
                }

                .search-input>div>button:hover {
                  background-color: rgba(160, 160, 171, 0.3) !important;
                }

                .btn-group>.btn.active {
                  background-color: rgba(160, 160, 171, 0.3) !important;
                }

                .btn-group>.btn {
                  background-color: transparent !important;
                  box-shadow: none !important;
              border: none !important;
                }

                .search-page>.search-results>div> :nth-child(2)>li.package .result-item-show-more {
                  background-color: rgba(160, 160, 171, 0.3) !important;
                }

                .nav-tabs li.active a,
                  .nav-tabs li.active a:focus,
                  .nav-tabs li.active a:hover {
              background: rgba(160, 160, 171, 0.3) !important;
                  }

                .search-page>.search-results>div> :nth-child(2)>li.package> :nth-child(5)> :nth-child(2) pre,
                  code {
                    background-color: rgba(34, 21, 81, 0.6) !important;
                  }
              }

              /***********************************************************/
              /*
              /* NOTE: Youtube-music
              /*
              /***********************************************************/

              @-moz-document domain("music.youtube.com") {
                :root {
                  --ytmusic-general-background-c: transparent !important;
                  --ytmusic-nav-bar: transparent !important;
                  --ytmusic-background: none !important;
                }
              }



              /***********************************************************/
              /*
              /* NOTE: Wikipedia
              /*
              /***********************************************************/
              @-moz-document domain("wikipedia.org") {
                :root {
                  --background-color-base: transparent !important;
                }

                html.skin-theme-clientpref-night .hatnote:not(.notheme),
                  html.skin-theme-clientpref-night .dablink:not(.notheme),
                  html.skin-theme-clientpref-night .rellink:not(.notheme),
                  html.skin-theme-clientpref-night .infobox:not(.notheme) {
                    background-color: transparent !important;
                    backdrop-filter: blur(10px) !important;
                  }
              }
          '';

          userChrome = ''
            html { background: transparent !important; }

            #main-window {
              background: transparent !important;
              -moz-appearance: transparent !important;
            }

            #tabbrowser-tabpanels { background: transparent !important; }
          '';

          search = {
            default = "DuckDuckGo";
            force = true;
            engines = {
              "Nix Packages" = {
                urls = [{
                  template = "https://search.nixos.org/packages";
                  params = [
                    { name = "type"; value = "packages"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
            };
          };

          settings = {
            "layout.css.devPixelsPerPx" = cfg.desktop.libreWolfScaleFactor;
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
      };
    };

    xdg.userDirs = {
      enable = true;
      createDirectories = true;

      desktop = "/home/bodby/.desktop";
      documents = "/home/bodby/docs";
      download = "/home/bodby/temp";
      templates = "/home/bodby/.templates";
      publicShare = "/home/bodby/.public";
      music = "/home/bodby/docs/music";
      pictures = "/home/bodby/docs/images";
      videos = "/home/bodby/docs/videos";

      extraConfig = {
        screenshots = "/home/bodby/docs/images/screenshots";
        projects = "/home/bodby/dev";
        vault = "/home/bodby/vault";
      };
    };

    fonts.fontconfig = {
      enable = cfg.desktop.enable;
      defaultFonts = {
        serif = [ "Ubuntu Sans" ];
        sansSerif = [ "Ubuntu Sans" ];
        monospace = [ "JetBrains Mono" ];
      };
    };

    home = {
      packages = with pkgs; [
        # inputs.iosevka-custom.packages.${system}.default
        ubuntu-sans
        jetbrains-mono
      ];

      pointerCursor = {
        gtk.enable = cfg.desktop.enable;
        x11.enable = cfg.desktop.enable;
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 24;
      };

      username = "bodby";
      homeDirectory = "/home/bodby";
      stateVersion = config.system.stateVersion;
    };

    manual = {
      html.enable = false;
      json.enable = false;
      manpages.enable = true;
    };
  };
}
