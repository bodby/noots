{ config, pkgs, ... }: {
  imports = [
    ../../modules/hardening.nix
    ../../users/bodby
  ];
}
