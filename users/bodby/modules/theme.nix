{
  lib,
  pkgs,
}:
{
  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      ubuntu-sans
    ];

    sans = "Ubuntu Sans";
    monospace = "JetBrains Mono";
  };

  palette = {
    bg = "131720";

    base01 = "0e1119";
    base02 = "f75f7b";
    base03 = "c4ef86";
    base04 = "ffba6b";
    base05 = "809fff";
    base06 = "b282fa";
    base07 = "89d8ff";
    base08 = "9fadc6";
    base09 = "212732";
    base10 = "f75f7b";
    base11 = "c4ef86";
    base12 = "ffba6b";
    base13 = "809fff";
    base14 = "b282fa";
    base15 = "89d8ff";
    base16 = "d4def3";
  };

  hexToRgb =
    hex:
    let
      hexToInt =
        str: index:
        let
          # I hate this so much.
          chars = [ "a" "b" "c" "d" "e" "f" ];
          hex' = builtins.substring index (index + 2) str;
        in
        lib.pipe hex' [
          lib.stringToCharacters
          (map (c:
            if builtins.elem (lib.toLower c) chars
            then lib.lists.findFirstIndex c + 10
            else lib.toInt c
          ))
          (lib.foldl (acc: x: acc * 8 + x) 0)
        ];
      in
      {
        r = hexToInt hex 0;
        g = hexToInt hex 2;
        b = hexToInt hex 4;
      };
}
