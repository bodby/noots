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

    iosevka-custom.url = "github:bodby/iosevka-custom";
    iosevka-custom.inputs.nixpkgs.follows = "nixpkgs";

    # ghostty.url = "github:ghostty-org/ghostty";
    # ghostty.inputs.nixpkgs-unstable.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      sops-nix,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      mkSystem =
        hostnameSet:
        nixpkgs.lib.attrsets.mapAttrs' (hostname: system: {
          name = hostname;
          value = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit system inputs;
            };

            modules = [
              home-manager.nixosModules.home-manager
              sops-nix.nixosModules.sops
              {
                home-manager.sharedModules = [ sops-nix.homeManagerModules.sops ];
                imports = [
                  (./. + "/hosts/${hostname}/config.nix")
                  (./. + "/hosts/${hostname}/hardware.nix")
                ];
              }
            ];
          };
        }) hostnameSet;
    in
    {
      formatter = nixpkgs.lib.genAttrs systems (
        system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style
      );

      nixosConfigurations = mkSystem {
        # Desktop
        sentinel = "x86_64-linux";
        # Laptop
        scout = "x86_64-linux";
        # NAS server
        # atlas = "x86_64-linux";
      };
    };
}
