final: prev:
let
  # https://ertt.ca/nix/shell-scripts
  # bashScript =
  #   {
  #     name,
  #     file,
  #     pkgs,
  #   }:
  #   let
  #     script = (final.writeShellScriptBin name (builtins.readFile file)).overrideAttrs (
  #       finalAttrs: {
  #         buildCommand = "${finalAttrs.buildCommand}\n patchShebangs $out";
  #       });
  #   in
  #   final.symlinkJoin {
  #     inherit name;
  #     paths = pkgs ++ [ script ];
  #     buildInputs = [ final.makeWrapper ];
  #     postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
  #   };
in
{
  # shantell-sans = final.callPackage ./shantell-sans.nix { };
  firefox-addons = final.callPackage ./firefox-addons.nix { };

  fix-laptop-speakers = final.writeShellApplication {
    name = "no-audio";
    text = builtins.readFile ./bin/fix-laptop-speakers.sh;
    runtimeInputs = with final; [
      bash
      alsa-utils
    ];
  };

  fix-g6-mic = final.writeShellApplication {
    name = "no-audio";
    text = builtins.readFile ./bin/fix-g6-mic.sh;
    runtimeInputs = with final; [
      bash
      alsa-utils
    ];
  };
}
