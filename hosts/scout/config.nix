{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

# TODO:
# - AppArmor.
# - No root login, use https://madaidans-insecurities.github.io/guides/linux-hardening.html#accessing-root-securely.
# - USBGuard.

{
  imports = [
    ../../modules
    ../../users/bodby
  ];

  networking.hostName = "scout";

  users.mutableUsers = true;
  modules.users.bodby = {
    gaming.enable = false;
    creative.enable = false;
    desktop = {
      enable = true;

      hyprland = {
        scale = 1.6;
        browserScale = 2.25;
        sensitivity = 0.5;
        border.radius = 16;
      };

      waybar.cpuTemp = "/sys/devices/platform/coretemp.0/hwmon/hwmon6/temp1_input";
    };
  };

  time.timeZone = "UTC";
  # TODO: Get iwd.
  networking = {
    wireless.enable = true;
    wireless.userControlled.enable = false;

    # I don't even have these configured; they are useless right now.
    firewall.enable = true;
    nftables.enable = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console.useXkbConfig = true;

  security = {
    sudo = {
      enable = true;
      package = pkgs.sudo';
      execWheelOnly = true;

      extraConfig = ''
        Defaults insults
        Defaults lecture=never
        Defaults passprompt="Enter passphrase for user '%p': "
        Defaults env_keep += "PS1 PS2 PROMPT_COMMAND"
      '';
    };

    rtkit.enable = config.services.pipewire.enable;

    # TODO: vvv
    apparmor.enable = true;
    apparmor.killUnconfinedConfinables = true;

    lockKernelModules = true;
    protectKernelImage = true;
  };

  systemd = {
    coredump.enable = false;
    coredump.extraConfig = ''
      Storage=none
    '';

    tmpfiles.settings = {
      # NOTE: I love consistency.
      #       tmpfiles(5) takes the earliest alphanumeric character (e.g. 00)
      #       while other services take the latest (e.g. 99)
      # "00-home-mode"."/home/*".Z.mode = "~0700";
      "00-nixos-mode"."/etc/nixos/*".Z = {
        mode = "0000";
        user = "root";
        group = "root";
      };
    };
  };

  services = {
    openssh.enable = false;
    libinput.enable = true;

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

    # See 'etc.issue'.
    # getty.greetingLine = "";

    resolved.dnssec = "true";
    # My systemd glibc laptop is now 100% secure!1!!
    jitterentropy-rngd.enable = true;
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

    less.lessopen = null;
  };

  xdg = {
    # autostart.enable = false;
    sounds.enable = false;
    # icons.enable = false;
    # mime.enable = false;
    # menus.enable = false;
  };

  environment = {
    systemPackages = with pkgs; [
      wget
      curl
      file
      fix-laptop-speakers
    ];

    defaultPackages = with pkgs; [
      rsync
      strace
    ];

    homeBinInPath = false;
    variables.NIX_SHELL_PRESERVE_PROMPT = 1;

    # TODO: Or try 'graphene-hardened-light'. I think this breaks LW.
    # memoryAllocator.provider = "graphene-hardened";

    # TODO: Should I disable this?
    stub-ld.enable = false;

    etc = {
      # FIXME: Do I really need this?
      # machine-id.text = "b08dfa6083e7567a1921a715000001fb";

      issue.text = ''

        [1;35mhttps://xkcd.com/272/[0m

      '';

      # From Kicksecure/security-misc.
      gitconfig.text = ''
        [core]
        	symlinks = false
        [transfer]
        	fsckobjects = true
        [fetch]
        	fsckobjects = true
        [receive]
        	fsckobjects = true
      '';

      "modprobe.d/conntrack.conf".text = "options nf_conntrack nf_conntrack_helper=0";

      # TODO: Copy 'boot.blacklistedKernelModules' but for this.
      "modprobe.d/disabled-modules.conf".text =
        let
          binFalse = "${pkgs.coreutils}/bin/false";
        in
        ''
          install bluetooth ${binFalse}
          install bluetooth_6lowpan ${binFalse}
          install bt3c_cs ${binFalse}
          install btbcm ${binFalse}
          install btintel ${binFalse}
          install btmrvl ${binFalse}
          install btmrvl_sdio ${binFalse}
          install btmtk ${binFalse}
          install btmtksdio ${binFalse}
          install btmtkuart ${binFalse}
          install btnxpuart ${binFalse}
          install btqca ${binFalse}
          install btrsi ${binFalse}
          install btrtl ${binFalse}
          install btsdio ${binFalse}
          install btusb ${binFalse}
          install virtio_bt ${binFalse}

          install asus_acpi ${binFalse}
          install bcm43xx ${binFalse}
          install de4x5 ${binFalse}
          install prism54 ${binFalse}

          install vivid ${binFalse}
          install floppy ${binFalse}
          install hamradio ${binFalse}

          install aty128fb ${binFalse}
          install atyfb ${binFalse}
          install cirrusfb ${binFalse}
          install cyber2000fb ${binFalse}
          install cyblafb ${binFalse}
          install gx1fb ${binFalse}
          install hgafb ${binFalse}
          install i810fb ${binFalse}
          # install intelfb ${binFalse}
          install kyrofb ${binFalse}
          install lxfb ${binFalse}
          install matroxfb_base ${binFalse}
          install neofb ${binFalse}
          install nvidiafb ${binFalse}
          install pm2fb ${binFalse}
          install radeonfb ${binFalse}
          install rivafb ${binFalse}
          install s1d13xxxfb ${binFalse}
          install savagefb ${binFalse}
          install sisfb ${binFalse}
          install sstfb ${binFalse}
          install tdfxfb ${binFalse}
          install tridentfb ${binFalse}
          install vesafb ${binFalse}
          install vfb ${binFalse}
          install viafb ${binFalse}
          install vt8623fb ${binFalse}
          install udlfb ${binFalse}

          install i2c_1801 ${binFalse}

          install sctp ${binFalse}
          install sctp_diag ${binFalse}

          install rds ${binFalse}
          install rds_rdma ${binFalse}
          install rds_tcp ${binFalse}

          install tipc ${binFalse}
          install tipc_diag ${binFalse}

          install c_can ${binFalse}
          install c_can_pci ${binFalse}
          install c_can_platform ${binFalse}
          install can ${binFalse}
          install can-bcm ${binFalse}
          install can-dev ${binFalse}
          install can-gw ${binFalse}
          install can-isotp ${binFalse}
          install can-raw ${binFalse}
          install can-j1939 ${binFalse}
          install can327 ${binFalse}
          install ifi_canfd ${binFalse}
          install janz-ican3 ${binFalse}
          install m_can ${binFalse}
          install m_can_pci ${binFalse}
          install m_can_platform ${binFalse}
          install phy-can-transceiver ${binFalse}
          install slcan ${binFalse}
          install ucan ${binFalse}
          install vxcan ${binFalse}
          install vcan ${binFalse}

          # TODO: Breaks VC?? Maybe???
          install atm ${binFalse}
          install ueagle-atm ${binFalse}
          install usbatm ${binFalse}
          install xusbatm ${binFalse}

          install af_802154 ${binFalse}
          install appletalk ${binFalse}
          install ax25 ${binFalse}
          install decnet ${binFalse}
          install dccp ${binFalse}
          install econet ${binFalse}
          install eepro100 ${binFalse}
          install eth1394 ${binFalse}
          install ipx ${binFalse}
          install n-hdlc ${binFalse}
          install netrom ${binFalse}
          install p8022 ${binFalse}
          install p8023 ${binFalse}
          install psnap ${binFalse}
          install rose ${binFalse}
          install x25 ${binFalse}

          install gfs2 ${binFalse}
          install ksmbd ${binFalse}

          install cifs ${binFalse}
          install cifs_arc4 ${binFalse}
          install cifs_md4 ${binFalse}

          install cramfs ${binFalse}
          install freevxfs ${binFalse}
          # TODO: Maybe don't remove hfs?
          install hfs ${binFalse}
          install hfsplus ${binFalse}
          install hpfs ${binFalse}
          install jffs2 ${binFalse}
          install jfs ${binFalse}
          install reiserfs ${binFalse}
          install udf ${binFalse}
          install adfs ${binFalse}
          install affs ${binFalse}
          install bfs ${binFalse}
          install befs ${binFalse}
          install efs ${binFalse}
          install erofs ${binFalse}
          install exofs ${binFalse}
          install f2fs ${binFalse}
          install minix ${binFalse}
          install nilfs2 ${binFalse}
          # TODO: Should I disable NTFS?
          install ntfs ${binFalse}
          install omfs ${binFalse}
          install qnx4 ${binFalse}
          install qnx6 ${binFalse}
          install sysv ${binFalse}
          install ufs ${binFalse}

          install pmt_class ${binFalse}
          install pmt_crashlog ${binFalse}
          install pmt_telemetry ${binFalse}

          # TODO: Maybe don't disable GPS.
          install garmin_gps ${binFalse}
          install gnss ${binFalse}
          install gnss-mtk ${binFalse}
          install gnss-serial ${binFalse}
          install gnss-sirf ${binFalse}
          install gnss-ubx ${binFalse}
          install gnss-usb ${binFalse}

          # Or wait until 2029 for FireWire to no longer be supported.
          install dv1394 ${binFalse}
          install firewire-core ${binFalse}
          install firewire-ohci ${binFalse}
          install firewire-net ${binFalse}
          install firewire-sbp2 ${binFalse}
          install ohci1394 ${binFalse}
          install raw1394 ${binFalse}
          install sbp2 ${binFalse}
          install video1394 ${binFalse}

          # FIXME: Disable once I have a NAS server.
          install cifs ${binFalse}
          install nfs ${binFalse}
          install nfsv3 ${binFalse}
          install nfsv4 ${binFalse}
          install ksmbd ${binFalse}
          install gfs2 ${binFalse}

          # FIXME: I don't normally use my webcam, but remove this if you need it.
          #        UEFI firmware also has an option to disable it, and I have a physical switch.
          install uvcvideo ${binFalse}

          # TODO: Only blacklist these (not disable) on PC.
          install cdrom ${binFalse}
          install sr_mod ${binFalse}
        '';
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      checkMeta = true;
      cudaSupport = false;
      warnUndeclaredOptions = true;
    };

    overlays = [
      (import ../../overlays)
      (import ../../pkgs)
    ];
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      channel.enable = false;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        flake-registry = "";
        fallback = true;
        auto-optimise-store = true;
        # https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
        allowed-users = [ "@users" ];
      };

      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  documentation = {
    enable = true;
    man.enable = true;
    doc.enable = true;
    nixos.enable = true;
    info.enable = false;
  };

  system.stateVersion = "24.11";
}
