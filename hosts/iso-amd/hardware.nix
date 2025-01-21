{
  lib,
  pkgs,
  ...
}:
{
  # https://nixos.wiki/wiki/Creating_a_NixOS_live_CD
  isoImage.squashfsCompression = "xz -Xdict-size 100%";

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = lib.mkForce [
    "ext4"
    "btrfs"
    "xfs"
    "zfs"
    "reiserfs"
    "f2fs"
    "ntfs"
    "vfat"
    "cifs"
  ];
}
