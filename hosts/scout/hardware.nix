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
    # Apparently 'nix-collect-garbage -d' doesn't remove old kernels in /boot.
    # You have to remove them manually.
    kernelPackages = pkgs.linuxPackages_6_12_hardened;
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
    # Very happy to see my system working the exact same as before.
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
      # TODO: Get AppArmor to enable namespaces only for LibreWolf.
      "kernel.unprivileged_userns_clone" = 1;
      "kernel.userns_restrict" = 0;
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
      "net.ipv6.conf.all.use_tempaddr" = lib.mkForce 2;
      "net.ipv6.conf.default.use_tempaddr" = lib.mkForce 2;
      # ??
      "net.ipv4.tcp_sack" = 0;
      "net.ipv4.tcp_dsack" = 0;
      "net.ipv4.tcp_fack" = 0;

      # Or 3 to disable 'ptrace' entirely.
      # 2 to restrict it to a capability.
      "kernel.yama.ptrace_scope" = 3;
      "vm.mmap_rnd_bits" = 32;
      "vm.mmap_rnd_compat_bits" = 16;
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
      "page_poison=1"
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
      "loglevel=0"

      # TODO: Anything on 'swapgs'?
      #       Also, does this render the params under it useless?
      "mitigations=auto,nosmt"
      # TODO: These are CPU-specific. How should I modularize these?
      "spectre_v1=on"
      "spectre_v2=on"
      "spectre_v2_user=on"
      "spectre_bhi=on"
      "spec_store_bypass_disable=on"

      "intel_iommu=on"
      "efi=disable_early_pci_dma"
      "iommu.passthrough=0"
      "iommu=force"
      "iommu.strict=1"

      # TODO: Override to allow 32-bit applications (this disables it).
      "ia32_emulation=0"
    ];

    blacklistedKernelModules = [
      "amd76x_edac"
      "ath_pci"
      "evbug"
      "pcspkr"
      "snd_aw2"
      "snd_intel8x0m"
      "snd_pcsp"
      "usbkbd"
      "usbmouse"

      # Breaks VirtualBox audio.
      # https://github.com/Kicksecure/security-misc/issues/271
      "snd_intel8x0"
      "tls"
      "virtio_balloon"
      "virtio_console"

      "cfg80211"
      "intel_agp"
      "ip_tables"
      "joydev"
      "mousedev"
      "psmouse"
    ];

    specialFileSystems = {
      "/dev/shm".options = [ "noexec" ];
      "/run".options = [ "noexec" ];
      "/dev".options = [ "noexec" ];

      # These prevent rebuilds.
      # "/var".options = [ "nosuid" ];

      # "/tmp".options = [
      #   "nosuid"
      #   "noexec"
      #   "nodev"
      # ];

      # See https://madaidans-insecurities.github.io/guides/linux-hardening.html#hidepid.
      # I don't know if I use systemd-login.
      "/proc".options = [
        "nosuid"
        "noexec"
        "nodev"
        "hidepid=2"
      ];
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/root";
      fsType = "xfs";
    };

    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [
        "nodev"
        "nosuid"
        "noexec"
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
