{
  programs.fzf = {
    enable = true;

    colors = {
      fg = "-1";
      bg = "-1";
      hl = "white:bold";

    };

    defaultOptions = [
      "--multi"
      "--layout=reverse"
      "--height=16"
      "--no-mouse"
      "--border=rounded"
      "--no-unicode"
      # "--info=hidden"
      "--scroll-off=8"
      "--separator="
    ];
  };
}
