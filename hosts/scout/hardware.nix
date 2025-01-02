{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "uas"
        "sd_mod"
      ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    # I'm completely lost.
    kernel.sysctl."fs.binfmt_misc.status" = "0";

    specialFileSystems = {
      "/dev/shm".options = [ "noexec" ];
      "/run".options = [ "noexec" ];
      "/dev".options = [ "noexec" ];
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/root";
      fsType = "xfs";
      options = [
        "nodev"
        "nosuid"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "xfs";
      options = [
        "nodev"
        "nosuid"
        # "noexec"
      ];
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
    priority = 200;
  };

  swapDevices = [{
    device = "/dev/disk/by-label/swap";
    priority = 100;
  }];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  services = {
    xserver.videoDrivers = [ "modesetting" ];
    printing.enable = false;
  };

  hardware = {
    graphics.enable = true;
    # See the screenshot at https://discourse.nixos.org/t/install-sound-open-firmware/6535/9.
    # Turns out I had my speakers muted...
    # firmware = with pkgs; [ sof-firmware ];
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
