{
  description = "Boilerplate";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nvim-btw.url = "git+https://codeberg.org/bodby/nvim-btw.git";
    nvim-btw.inputs.nixpkgs.follows = "nixpkgs";

    templates.url = "github:bodby/templates";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      mkSystem = nixpkgs.lib.attrsets.mapAttrs (hostname: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit system inputs; };
          modules = [
            {
              imports = [
                (./. + "/hosts/${hostname}/config.nix")
                (./. + "/hosts/${hostname}/hardware.nix")
              ];
            }
          ];
        });
    in {
      nixosConfigurations = mkSystem {
        sentinel = "x86_64-linux";
        scout = "x86_64-linux";
      };
    };
}
