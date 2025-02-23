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
        useOSProber = true;
        # copyKernels = true;
      };
    };

    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ ];

      systemd.network.wait-online.enable = false;
      systemd.network.wait-online.timeout = 1;
    };

    kernelModules = [
      "kvm-amd"
      "nvidia-uvm"
    ];
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

  # networking.useDHCP = true;
  # networking.interfaces.enp8s0.useDHCP = lib.mkDefault true;
  # Handled by IWD instead of DHCPCD.
  # TODO: Move IWD config to 'hardware.nix'.
  networking.interfaces.wlp7s0.useDHCP = true;

  services = {
    xserver.videoDrivers = [ "nvidia" ];
    printing.enable = false;
  };

  hardware = {
    graphics.enable = true;
    nvidia = {
      open = true;
      nvidiaSettings = false;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = true;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
