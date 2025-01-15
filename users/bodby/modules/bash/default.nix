{
  home-manager.users.bodby.programs = {
    bash = {
      enable = true;
      historyControl = [ "erasedups" ];
      historyFile = null;
      shellAliases.ls = "ls --color=always -h -A -p --time-style=long-iso";
      # FIXME: Don't use a command and just set $PS1 directoy if this doesn't carry over to root shells.
      initExtra = builtins.readFile ./prompt.bash;
    };

    dircolors = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = false;
      enableZshIntegration = false;
      settings = {
        DIR = "00;37";
        LINK = "00;35";
        RESET = "\\033[00;97";
        EXEC = "01;97";
      };
    };

    readline = {
      enable = true;
      includeSystemConfig = false;

      bindings = {
        "\\C-p" = "history-search-backward";
        "\\C-n" = "history-search-forward";
      };

      variables = {
        bell-style = "none";
        meta-flag = true;
        convert-meta = false;
        output-meta = true;
        colored-stats = true;
        mark-directories = true;
        completion-ignore-case = true;
        completion-prefix-display-length = 3;
        mark-symlinked-directories = true;
        show-all-if-ambiguous = true;
        show-all-if-unmodified = true;
        visible-stats = false;
      };
    };
  };
}
