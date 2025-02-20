{
  config,
  lib,
  pkgs,
  ...
}:
let dir = config.home-manager.users.bodby.xdg.userDirs.templates; in {
  home-manager.users.bodby.home.file."${dir}" = {
    recursive = true;
    source = ../templates;
  };
}
