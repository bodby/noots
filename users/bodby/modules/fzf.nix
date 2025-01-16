{
  home-manager.users.bodby.programs.fzf = {
    enable = true;

    # NOTE: FZF Bash integration breaks things.
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableZshIntegration = false;

    colors = {
      fg = "bright-black";
      selected-fg = "bright-white:bold";
      bg = "-1";
      selected-bg = "-1";
      hl = "bright-black:bold";
      selected-hl = "white:bold";
      # TODO: Where are these applied?
      current-fg = "bright-white:bold";
      current-bg = "-1";
      current-hl = "bright-white:bold";
      query = "white";
      disabled = "bright-black";
      border = "black";
      separator = "black";
      marker = "white";
      # TODO: Does this work?
      # spinner = "-1";
    };

    defaultOptions = [
      "--multi"
      "--cycle"
      "--wrap"
      "--no-mouse"
      "--no-info"
      "--no-scrollbar"

      "--no-multi-line"
      "--layout=default"
      "--padding=0"
      "--tabstop=4"

      # "--border-label='fzf'"
      # "--border-label-pos=2"
      "--border=rounded"
      "--wrap-sign='+'"
      "--separator='─'"
      "--prompt=''"
      "--pointer=''"
      "--marker='+'"
      # TODO: This.
      "--marker-multi-line='+++'"
      "--ellipsis=''"

      "--height=32"
      "--scroll-off=0"
    ];
  };
}
