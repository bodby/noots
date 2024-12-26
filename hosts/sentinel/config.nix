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
    firewall.enable = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console.useXkbConfig = true;

  security = {
    sudo = {
      enable = true;
      package = pkgs.sudo';
      extraConfig = ''
        Defaults insults
        Defaults pwfeedback
        Defaults lecture=never
        Defaults passprompt="Enter passphrase for user '%p': "
      '';
    };

    rtkit.enable = config.services.pipewire.enable;
  };

  systemd.coredump.enable = false;

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

    # This is just overkill.
    blocky = {
      enable = true;
      settings = {
        ports.dns = 53;
        upstreams.groups.default = [ "1.1.1.1" ];

        blocking = {
          denylists = {
            ads = [
              "https://raw.githubusercontent.com/StevenBlack/hosts/hosts"
              "https://raw.githubusercontent.com/shreyasminocha/shady-hosts/a5647df22b0dc5ff6c866f21ee2d8b588682626a/hosts"
              "https://blocklistproject.github.io/Lists/tiktok.txt"
              "https://blocklistproject.github.io/Lists/tracking.txt"
            ];

            # I hope I don't ever need this.
            haram = [
              "https://blocklistproject.github.io/Lists/porn.txt"
              "https://blocklistproject.github.io/Lists/abuse.txt"
              "https://blocklistproject.github.io/Lists/drugs.txt"
              "https://blocklistproject.github.io/Lists/fraud.txt"
              "https://blocklistproject.github.io/Lists/gambling.txt"
              "https://blocklistproject.github.io/Lists/malware.txt"
              "https://blocklistproject.github.io/Lists/phishing.txt"
              "https://blocklistproject.github.io/Lists/piracy.txt"
              "https://blocklistproject.github.io/Lists/ransomware.txt"
              "https://blocklistproject.github.io/Lists/redirect.txt"
              "https://blocklistproject.github.io/Lists/scam.txt"
              "https://raw.githubusercontent.com/StevenBlack/hosts/alternates/fakenews-gambling-porn/hosts"

              # :)
              "https://blocklistproject.github.io/Lists/adobe.txt"
            ];
          };

          clientGroupBlocks.default = [
            "ads"
            "haram"
          ];
        };
      };
    };
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
    ];

    homeBinInPath = true;
    variables.NIX_SHELL_PRESERVE_PROMPT = 1;

    etc.inputrc.source = ./inputrc;
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
