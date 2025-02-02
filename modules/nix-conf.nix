{
  config,
  lib,
  inputs,
  ...
}:
{
  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      channel.enable = false;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        flake-registry = "";
        fallback = true;
        auto-optimise-store = true;
        # https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
        pure-eval = true;
        log-lines = 48;
        # NOTE: vvv
        http2 = false;
        connect-timeout = 30;
        allowed-users = [ "@users" ];
      };

      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };
}
