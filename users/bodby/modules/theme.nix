pkgs:
let
  inherit (pkgs) lib;
in {
  fonts = {
    packages = with pkgs; [
      # jetbrains-mono
      cascadia-code
      # nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      ubuntu-sans
    ];

    sans = "Ubuntu Sans";
    monospace = "Cascadia Code";
    icons = "Symbols Nerd Font";
  };

  palette = {
    bg = "0e1119";
    bgDark = "0a0d14";

    base01 = "141924";
    base02 = "f75fa8";
    base03 = "bbef86";
    base04 = "ffb96b";
    base05 = "809cff";
    base06 = "9d7dff";
    base07 = "89bcff";
    base08 = "91a4ca";
    base09 = "495674";
    base10 = "f75fa8";
    base11 = "bbef86";
    base12 = "ffb96b";
    base13 = "809cff";
    base14 = "9d7dff";
    base15 = "89bcff";
    base16 = "aec5f2";
  };

  hexToRgb = hex:
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
      in {
        r = hexToInt hex 0;
        g = hexToInt hex 2;
        b = hexToInt hex 4;
      };
}
