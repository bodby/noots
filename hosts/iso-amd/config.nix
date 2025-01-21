{
  config,
  lib,
  pkgs,
  inputs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  networking.hostName = "nixos";
  users.users.root.initialPassword = "nixos";

  time.timeZone = "UTC";
  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";
  console.useXkbConfig = false;

  security.sudo = {
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

  systemd.coredump.enable = false;
  systemd.coredump.extraConfig = ''
    Storage=none
  '';

  services.jitterentropy-rngd.enable = true;

  programs.command-not-found.enable = false;
  programs.less.lessopen = null;

  environment = {
    systemPackages = with pkgs; [
      wget
      curl
      file
      bc
      killall
      time

      ddrescue

      age
      sops

      inputs.nvim-btw.packages.${system}.default

      (haskellPackages.ghcWithPackages (pkgs: with pkgs; [
        cabal-install
        haskell-language-server
      ]))

      # TODO: This and Hyprland?
      # neovide
    ];

    etc = {
      issue.text = ''

        Root password is "nixos".
        See 'nixos-help' for how to use wpa_cli.

      '';

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
    };
  };

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
      # FIXME: Will this break anything?
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
}
