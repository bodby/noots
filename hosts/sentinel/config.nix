{
  config,
  lib,
  pkgs,
  inputs,
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
    desktop.enable = true;
    gaming.enable = true;
    creative.enable = true;
  };

  time.timeZone = "UTC";

  networking = {
    wireless.enable = true;
    wireless.userControlled.enable = false;

    # I don't even have these configured; they are useless right now.
    firewall.enable = true;
    nftables.enable = true;

    dhcpcd.wait = "if-carrier-up";
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
  };

  systemd = {
    coredump.enable = false;
    coredump.extraConfig = ''
      Storage=none
    '';
    tmpfiles.settings = {
      # "restricthome"."/home/*".Z.mode = lib.mkDefault "~0700";
      # TODO: Rename this.
      "restrictetcnixos"."/etc/nixos/*".Z = {
        mode = lib.mkDefault "0000";
        user = lib.mkDefault "root";
        group = lib.mkDefault "root";
      };
    };
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
    doc.enable = false;
    nixos.enable = true;
    info.enable = false;
  };

  system.stateVersion = "24.05";
}
