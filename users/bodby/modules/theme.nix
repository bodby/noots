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
    bg = "000000";

    # TODO: Actual ANSI colors (not grays).
    base01 = "242429";
    base02 = "d16556";
    base03 = "44ae6e";
    base04 = "d79b48";
    base05 = "7289fd";
    base06 = "936df3";
    base07 = "82cfff";
    base08 = "9999a4";
    base09 = "52525a";
    base10 = "d16556";
    base11 = "44ae6e";
    base12 = "edb15b";
    base13 = "8b9efd";
    base14 = "b294ff";
    base15 = "82cfff";
    base16 = "d2d2e0";
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
