{
  config,
  lib,
  pkgs,
  ...
}:

# TODO: Make this use the Nix flake templates repo.
let
  dir = config.home-manager.users.bodby.xdg.userDirs.templates;
in {
  home-manager.users.bodby.home.file."${dir}" = {
    recursive = true;
    source = ../templates;
  };
}
