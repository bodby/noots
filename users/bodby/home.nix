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
      # Will move everything to sops once I actually have a workijg
      # secrets.git_signature = { };
    };

    programs = {
      home-manager.enable = true;

      git = {
        enable = true;
        userName = "Baraa Homsi";
        userEmail = "baraa.homsi@proton.me";
        extraConfig = {
          init.defaultBranch = "master";

          gpg.format = "ssh";
          # TODO: Move to sops or a file inside the actual NixOS configuration.
          gpg.ssh.allowedSignersFile = "/home/bodby/.config/git/allowed_signers";
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

      # bash = {
      #   enable = false;
      #   enableCompletion = true;
      #   historyControl = [ "erasedups" ];
      #   shellAliases.ls = "ls --color=always -h -A -p --time-style=long-iso";
      #   initExtra = "set -o vi";
      # };

      # dircolors = {
      #   enable = true;
      #   enableBashIntegration = true;
      #   enableZshIntegration = false;
      #   enableFishIntegration = false;
      #   settings = {
      #     DIR = "00;37";
      #     LINK = "00;35";
      #     EXEC = "01;97";
      #     RESET = "00;97";
      #   };
      # };

      librewolf = {
        enable = cfg.desktop.enable;
        package = pkgs.librewolf';
        settings = {
          "layout.css.devPixelsPerPx" = "1.125";
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

    wayland.windowManager.hyprland = {
      enable = cfg.desktop.enable;
      xwayland.enable = cfg.desktop.enable;
      plugins = [ pkgs.hyprlandPlugins.hyprscroller ];

      settings = {
        monitor = [
          "DP-2, 2560x1440@239.96Hz, 0x0, 1"
          ", preferred, auto, 1"
        ];
        source = [
          "./programs.conf"
          "./input.conf"
          "./layout.conf"
          "./rules.conf"
          "./theme.conf"
        ] ++ lib.optional (builtins.elem "nvidia" config.services.xserver.videoDrivers) "./nvidia.conf";
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
        inputs.iosevka-custom.packages.${system}.default
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

      sessionVariables = {
        SUDO_PROMPT = "Enter sudo password (%p@%h as %U): ";
      };

      username = "bodby";
      homeDirectory = "/home/bodby";
      stateVersion = config.system.stateVersion;
    };
  };
}
