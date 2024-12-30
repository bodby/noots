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
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console.useXkbConfig = true;

  security = {
    sudo = {
      enable = true;
      package = pkgs.sudo';
      extraConfig = ''
        Defaults insults
        Defaults lecture=never
        Defaults passprompt="Enter passphrase for user '%p': "
        Defaults env_keep += "PS1 PS2 PROMPT_COMMAND"
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
    ];

    homeBinInPath = true;
    variables.NIX_SHELL_PRESERVE_PROMPT = 1;
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
