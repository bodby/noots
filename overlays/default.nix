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


  # FIXME: Remove after a week.
  hyprscroller' = prev.hyprlandPlugins.hyprscroller.overrideAttrs(finalAttrs:
    {
      version = "e4b1354";
      src = final.fetchFromGitHub {
        owner = "dawsers";
        repo = "hyprscroller";
        rev = "e4b13544ef3cc235eb9ce51e0856ba47eb36e8ac";
        hash = "sha256-OYCcIsE25HqVBp8z76Tk1v+SuYR7W1nemk9mDS9GHM8=";
      };
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
