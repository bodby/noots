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
    kernelPackages = pkgs.linuxPackages_latest_hardened;
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
    kernel.sysctl = {
      "fs.binfmt_misc.status" = 0;
      "kernel.kptr_restrict" = 1;
      "kernel.dmesg_restrict" = 1;
      "kernel.printk" = "3 3 3 3";
      "kernel.unprivileged_bpf_disabled" = 1;
      "net.core.bpf_jit_harden" = 2;
      "dev.tty.ldisc_autoload" = 0;
      "vm.unprivileged_userfaultfd" = 0;
      # Lowest this should go is 1. Default is 60.
      "vm.swappiness" = 10;
      "kernel.kexec_load_disabled" = 1;
      # Or 4 if you want this enabled.
      "kernel.sysrq" = 0;
      # I don't know if I have this patch.
      "kernel.unprivileged_userns_clone" = 0;
      # If above doesn't work:
      # "user.max_user_namespaces" = 0;
      "kernel.perf_event_paranoid" = 2;

      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.tcp_rfc1337" = 1;
      "net.ipv4.tcp_timestamps" = 0;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.icmp_echo_ignore_all" = 1;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv4.conf.default.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.default.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_ra" = 0;
      "net.ipv6.conf.default.accept_ra" = 0;
      "net.ipv6.conf.all.use_tempaddr" = 2;
      "net.ipv6.conf.default.use_tempaddr" = 2;
      # ??
      "net.ipv4.tcp_sack" = 0;
      "net.ipv4.tcp_dsack" = 0;
      "net.ipv4.tcp_fack" = 0;

      # Or 3 to disable 'ptrace' entirely.
      "kernel.yama.ptrace_scope" = 2;
      "vm.mmap_rnd_bits" = 64;
      "vm.mmap_rnd_compat_bits" = 32;
      # Would this break HM?
      "fs.protected_symlinks" = 1;
      "fs.protected_hardlinks" = 1;

      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2;
    };

    kernelParams = [
      "quiet"
      "init_on_alloc=1"
      "init_on_free=1"
      # https://madaidans-insecurities.github.io/guides/linux-hardening.html
      # Apparently this improves allocation performance?
      "page_alloc.shuffle=1"
      "pti=on"
      "randomize_kstack_offset=on"
      "vsyscalls=none"
      "debugfs=off"
      # "oops=panic"
      # Might also break something.
      "module.sig_enforce=1"
      "lockdown=confidentiality"
      # I don't want to open my laptop and check.
      "mce=0"
      # TODO: Anything on 'swapgs'?
      "loglevel=0"
      "spectre_v1=on"
      "spectre_v2=on"
      "spectre_v2_user=on"
      "spectre_bhi=on"
      "spec_store_bypass_disable=on"

      "intel_iommu=on"
      # TODO: ???
      "efi=disable_early_pci_dma"
    ];

    specialFileSystems = {
      "/dev/shm".options = [ "noexec" ];
      "/run".options = [ "noexec" ];
      "/dev".options = [ "noexec" ];
      # May break desktops.
      # See https://madaidans-insecurities.github.io/guides/linux-hardening.html#hidepid.
      # I don't know if I use systemd-login.
      "/proc".options = [
        "nosuid"
        "noexec"
        "nodev"
        "hidepid=2"
        "gid=${toString config.users.groups.proc.gid}"
      ];
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
        # I don't have Steam games so this should be fine.
        "noexec"
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
