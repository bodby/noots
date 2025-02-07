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
      version = "964aced";
      src = final.fetchFromGitHub {
        owner = "dawsers";
        repo = "hyprscroller";
        rev = "964aced89f5711e1d2fce17fc990c1148da42145";
        hash = "";
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
