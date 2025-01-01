final: prev: {
  # foo-bar = final.callPackage ./foo-bar.nix { };
  # shantell-sans = final.callPackage ./shantell-sans.nix { };

  fix-laptop-speakers = final.writeShellScriptBin "fix-laptop-speakers" ''
    ${final.alsa-utils}/bin/amixer -c 0 set Speaker unmute
  '';
  # TODO: This for my Sound Blaster.
  fix-g6-mic = final.writeShellScriptBin "fix-g6-mic" ''
    ${final.alsa-utils}/bin/amixer -c 0 set Speaker unmute
  '';
}
