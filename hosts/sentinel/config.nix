{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules
    ../../users/bodby
  ];

  networking.hostName = "sentinel";

  users.mutableUsers = true;
  modules.users.bodby = {
    gaming.enable = true;
    creative.enable = true;
    desktop = {
      enable = true;
      wallpaper = "lighthouse.png";
      hyprland.border.radius = 16;
    };
  };

  time.timeZone = "UTC";

  networking = {
    resolvconf.enable = true;
    wireless.enable = false;
    # wireless.userControlled.enable = false;

    # Ever since I got IWD my internet just decided to stop functioning.
    # Even when I switched back to wpa_supplicant.
    wireless.iwd = {
      enable = true;
      settings = {
        IPv6.Enabled = true;
        Network = {
          EnableIPv6 = true;
          NameResolvingService = "resolvconf";
          # FIXME: What does this do??
          #        Magic number, therefore I touch.
          RoutePriorityOffset = 50;
        };
        Settings = {
          AutoConnect = true;
          TransitionDisable = true;
          DisabledTransitionModes = "personal,enterprise,open";
        };
        General = {
          EnableNetworkConfiguration = true;
          AddressRandomization = "network";
          AddressRandomizationRange = "nic";
          # I can't find the link for this but this was somebody's solution to random disconnects.
          # FIXME: Remove this, most likely unneeded.
          ControlPortOverNL80211 = false;
        };
      };
    };

    # I don't even have these configured; they are useless right now.
    firewall = {
      enable = true;
      # MC.
      allowedTCPPorts = [ 63645 ];
      allowedUDPPorts = [ 63645 ];
    };
    nftables.enable = true;

    dhcpcd.enable = false;
    dhcpcd.wait = "if-carrier-up";
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console.useXkbConfig = true;

  security = {
    sudo = {
      enable = true;
      package = pkgs.sudo';
      execWheelOnly = true;

      # Defaults env_keep += "PS1 PS2 PROMPT_COMMAND"
      extraConfig = ''
        Defaults insults
        Defaults lecture=never
        Defaults passprompt="Enter passphrase for user '%p': "
      '';
    };

    rtkit.enable = config.services.pipewire.enable;
  };

  systemd = {
    coredump.enable = false;
    coredump.extraConfig = ''
      Storage=none
    '';

    tmpfiles.settings = {
      # NOTE: This adds an extra ~10 seconds to my startup time.
      # "00-home-mode"."/home/*".Z.mode = "~0700";
      "00-nixos-mode"."/etc/nixos/*".Z = {
        mode = "0000";
        user = "root";
        group = "root";
      };
    };

    network.enable = false;
  };

  security.pam.services.su.requireWheel = true;
  security.pam.services.su-l.requireWheel = true;

  services = {
    openssh.enable = false;

    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };

    xserver = {
      enable = false;
      xkb.layout = "us";
      # Use Alt+Caps Lock to toggle Caps Lock.
      xkb.options = "grp:caps_switch";
    };

    getty.greetingLine = "";
    resolved.enable = false;
  };

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      withNodeJs = false;
      withPython3 = false;
      withRuby = false;
      viAlias = true;
      vimAlias = true;
    };

    git.enable = true;
    command-not-found.enable = false;

    ssh.knownHosts.github = {
      hostNames = [ "github.com" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    };
  };

  environment = {
    systemPackages = with pkgs; [
      wget
      curl
      file
      fix-g6-mic
    ];

    homeBinInPath = false;
    variables.NIX_SHELL_PRESERVE_PROMPT = 1;

    etc."modprobe.d/nm-disable-bluetooth.conf".text = ''
      install bluetooth /usr/bin/disabled-bluetooth-by-security-misc
      install bluetooth_6lowpan  /usr/bin/disabled-bluetooth-by-security-misc
      install bt3c_cs /usr/bin/disabled-bluetooth-by-security-misc
      install btbcm /usr/bin/disabled-bluetooth-by-security-misc
      install btintel /usr/bin/disabled-bluetooth-by-security-misc
      install btmrvl /usr/bin/disabled-bluetooth-by-security-misc
      install btmrvl_sdio /usr/bin/disabled-bluetooth-by-security-misc
      install btmtk /usr/bin/disabled-bluetooth-by-security-misc
      install btmtksdio /usr/bin/disabled-bluetooth-by-security-misc
      install btmtkuart /usr/bin/disabled-bluetooth-by-security-misc
      install btnxpuart /usr/bin/disabled-bluetooth-by-security-misc
      install btqca /usr/bin/disabled-bluetooth-by-security-misc
      install btrsi /usr/bin/disabled-bluetooth-by-security-misc
      install btrtl /usr/bin/disabled-bluetooth-by-security-misc
      install btsdio /usr/bin/disabled-bluetooth-by-security-misc
      install btusb /usr/bin/disabled-bluetooth-by-security-misc
      install virtio_bt /usr/bin/disabled-bluetooth-by-security-misc
    '';
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      checkMeta = true;
      cudaSupport = true;
      warnUndeclaredOptions = true;
    };

    overlays = [
      (import ../../overlays)
      (import ../../pkgs)
    ];
  };

  documentation = {
    enable = true;
    man.enable = true;
    doc.enable = false;
    nixos.enable = true;
    info.enable = false;
  };

  system.stateVersion = "24.05";
}
