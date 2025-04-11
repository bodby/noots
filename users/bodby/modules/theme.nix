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
    bgTranslucent = "07090f";

    # base01 = "141924";
    base01 = "0e1119";
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
}
