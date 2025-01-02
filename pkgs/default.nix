final: prev:
let
  # https://ertt.ca/nix/shell-scripts
  bashScript =
    {
      name,
      file,
      pkgs,
    }:
      let
        script = (final.writeShellScriptBin name (builtins.readFile file)).overrideAttrs (
          finalAttrs: {
            buildCommand = "${finalAttrs.buildCommand}\n patchShebangs $out";
          });
      in
      final.symlinkJoin {
        inherit name;
        paths = pkgs ++ [ script ];
        buildInputs = final.makeWrapper;
        postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
      };
in
{
  # foo-bar = final.callPackage ./foo-bar.nix { };
  # shantell-sans = final.callPackage ./shantell-sans.nix { };

  fix-laptop-speakers = bashScript {
    name = "fix-laptop-speakers";
    file = ./bin/fix-laptop-speakers.sh;
    pkgs = with final; [ alsa-utils ];
  };

  fix-g6-mic = bashScript {
    name = "fix-g6-mic";
    file = ./bin/fix-g6-mic.sh;
    pkgs = with final; [ alsa-utils ];
  };
}
