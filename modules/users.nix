{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
let
  # extraSpecialArgs = {
  #   inherit config lib pkgs inputs system;
  # };

  userList = config.modules.users.users;
in
{
  config.users.users = builtins.listToAttrs (
    map (user: {
      name = user;
      value = import (../. + "/users/${user}/user.nix") {
        inherit
          config
          lib
          pkgs
          inputs
          system
          ;
      };
    }) userList
  );

  config.home-manager.users = builtins.listToAttrs (
    map (user: {
      name = user;
      value = import (../. + "/users/${user}/home.nix") { inherit config lib pkgs; };
    }) userList
  );
}
