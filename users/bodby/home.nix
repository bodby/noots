{
  config,
  lib,
  pkgs,
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
        settings = {
          "layout.css.devPixelsPerPx" = cfg.desktop.libreWolfScaleFactor;
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
