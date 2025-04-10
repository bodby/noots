final: prev: {
  sudo' = prev.sudo.override {
    withInsults = true;
  };

  librewolf' = prev.librewolf.override {
    cfg.speechSynthesisSupport = false;
  };

  krita' = prev.krita.override {
    binaryPlugins = [ prev.pkgs.krita-plugin-gmic ];
  };

  ghostty' = prev.ghostty.override {
    withAdwaita = false;
  };

  steam' =
    let
      extraCompatPackages = [ final.proton-ge-bin ];
      extraCompatPaths = final.lib.makeSearchPathOutput "steamcompattool" "" extraCompatPackages;
    in
    prev.steam.override {
      extraEnv = (final.lib.optionalAttrs (extraCompatPackages != [ ]) {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = extraCompatPaths;
      });
    };

  # FIXME: Remove when nixpkgs version reaches 2025-03-24.
  hyprscroller' = prev.hyprlandPlugins.hyprscroller.overrideAttrs (finalAttrs: {
    version = "0-unstable-2025-03-25";
    src = final.fetchFromGitHub {
      owner = "dawsers";
      repo = "hyprscroller";
      rev = "b14552ac3a62e24b059eb7569077c75547d5cc69";
      hash = "sha256-e3AFZnfTqaqExi9eBGTcTDV7IghJ9fisJPKxgPG+h0g=";
    };
  });

  # https://github.com/pwmt/zathura/issues/729
  zathura' = prev.zathura.override (finalAttrs: {
    useMupdf = true;
  });

  # rofi-wayland-unwrapped = prev.rofi-wayland-unwrapped.overrideAttrs (
  #   {
  #     patches ? [ ],
  #     ...
  #   }:
  #   {
  #     patches = patches ++ [
  #       # Fixes Rofi not capturing input as of 2024-11-27.
  #       # This was fixed, but I'm leaving this here to easily apply future patches.
  #       # (prev.fetchpatch {
  #       #   url = "https://github.com/samueldr/rofi/commit/55425f72ff913eb72f5ba5f5d422b905d87577d0.patch";
  #       #   hash = "sha256-vTUxtJs4SuyPk0PgnGlDIe/GVm/w1qZirEhKdBp4bHI=";
  #       # })
  #     ];
  #   }
  # );
}
