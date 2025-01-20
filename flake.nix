{
  description = "Boilerplate";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nvim-btw.url = "github:bodby/nvim-btw";
    nvim-btw.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      sops-nix,
      ...
    }@inputs:
    let
      mkSystem =
        hostnameSet:
        nixpkgs.lib.attrsets.mapAttrs (hostname: system:
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit system inputs; };

            modules = [
              home-manager.nixosModules.home-manager
              # sops-nix.nixosModules.sops
              {
                home-manager.sharedModules = [ sops-nix.homeManagerModules.sops ];
                imports = [
                  (./. + "/hosts/${hostname}/config.nix")
                  (./. + "/hosts/${hostname}/hardware.nix")
                ];
              }
            ];
          }) hostnameSet;
    in
    {
      nixosConfigurations = mkSystem {
        # Desktop
        sentinel = "x86_64-linux";
        # Laptop
        scout = "x86_64-linux";
        # TODO: Home server ('atlas') and ISO.
      };
    };
}
