{
  lib,
  pkgs,
}:
{
  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      ubuntu-sans
    ];

    sans = "Ubuntu Sans";
    monospace = "JetBrains Mono";
    # This should not be "Mono" or "Propo"; just "Nerd Font".
    monospace' = "JetBrainsMono Nerd Font";
  };

  palette = {
    bg = "131720";

    base01 = "0e1119";
    base02 = "f75f8d";
    base03 = "bbef86";
    base04 = "ffb06b";
    base05 = "809fff";
    base06 = "a87dff";
    base07 = "89bcff";
    base08 = "99a7c2";
    base09 = "1c2330";
    base10 = "f75f8d";
    base11 = "bbef86";
    base12 = "ffb06b";
    base13 = "809fff";
    base14 = "a87dff";
    base15 = "89bcff";
    base16 = "c2d5ff";
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
