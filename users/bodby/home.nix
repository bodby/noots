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

      # Still figuring this out.
      # Will move everything to sops once I actually have it working.
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
          "3rdparty".Extensions = {
            "{d7742d87-e61d-4b78-b8a1-b469842139fa}".adminSettings = {
              scrollStepSize = 120;
              smoothScroll = false;
              grabBackFocus = true;
              searchUrl = "https://duckduckgo.com/?q=";
              settingsVersion = "2.1.2";
              userDefinedLinkHintCss = "div > .vimiumHintMarker {\n  background: #0d0d0f;\n  border: none;\n  padding: 6px;\n  border-radius: 0;\n  box-shadow: none;\n}\n\ndiv > .vimiumHintMarker span {\n  font-family: monospace !important;\n  color: #9393a2;\n  font-weight: normal;\n}\n\ndiv > .vimiumHintMarker > .matchingCharacter {\n  color: #d2d2df;\n  font-weight: bold;\n}\n\n#vomnibar {\n  background: #0b0b0d;\n  color: #d2d2df;\n  border-radius: 12px;\n  box-shadow: none;\n  border: none;\n}\n\n#vomnibar input {\n  font-family: monospace !important;\n  color: #d2d2df;\n  font-size: 24px;\n  height: auto;\n  margin-bottom: 0;\n  padding: 15px;\n  background-color: unset;\n  border-radius: 12px;\n  border: none;\n  box-shadow: none;\n}\n\n#vomnibar .vomnibarSearchArea {\n  padding: 0;\n  background-color: unset;\n  border-radius: 12px 12px 0 0;\n  border-bottom: none;\n}\n\n#vomnibar ul {\n  background-color: rgba(76, 86, 106, 0.8);\n}\n\n#vomnibar li {\n  border-bottom: 1px solid rgba(255,255,255,0.1);\n  color: #E5E9F0;\n}\n\n#vomnibar li.vomnibarSelected {\n  background-color: rgba(136, 192, 208, 1);\n}\n\n#vomnibar li .vomnibarSource {\n  color: #D8DEE9;\n}\n\n#vomnibar li em, #vomnibar li .vomnibarTitle {\n  color: #ECEFF4;\n}\n\n#vomnibar li .vomnibarUrl {\n  color: #88C0D0;\n}\n\n#vomnibar li .vomnibarMatch {\n  color: #EBCB8B;\n}\n\n#vomnibar li em .vomnibarMatch, #vomnibar li .vomnibarTitle .vomnibarMatch {\n  color: #EBCB8B;\n}\n\n#vomnibar li.vomnibarSelected .vomnibarSource {\n  color: #4C566A;\n}\n\n#vomnibar li.vomnibarSelected em, #vomnibar li.vomnibarSelected .vomnibarTitle {\n  color: #3B424F;\n}\n\n#vomnibar li.vomnibarSelected .vomnibarUrl {\n  color: #4C566A;\n}\n\n#vomnibar li.vomnibarSelected .vomnibarMatch {\n  color: #2E3440;\n}";
            };
          };
        };

        # TODO: Custom CSS.
        profiles.bodby = {
          isDefault = true;
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
          extensions = with inputs.nur.legacyPackages.${system}.repos.rycee.firefox-addons; [
            vimium
            ublock-origin
          ];

          settings = {
            # "layout.css.devPixelsPerPx" = cfg.desktop.libreWolfScaleFactor;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "extensions.autoDisableScopes" = 0;

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
      manpages.enable = false;
    };
  };
}
