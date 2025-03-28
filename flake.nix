{
  description = "Boilerplate";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Mirror at https://github.com/bodby/nvim-btw.
    nvim-btw.url = "git+https://codeberg.org/bodby/nvim-btw.git";
    nvim-btw.inputs.nixpkgs.follows = "nixpkgs";

    # templates.url = "github:bodby/templates";
    flakes.url = "git+https://codeberg.org/bodby/flakes.git";
  };

  outputs =
    {
      self,
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
    in {
      # TODO: GUI for ISOs (I need Neovide).
      nixosConfigurations = mkSystem {
        # Desktop
        sentinel = "x86_64-linux";
        # Laptop
        scout = "x86_64-linux";
        # TODO: Home server ("atlas").

        # NOTE: To build ISOs, run the command below or just 'nix build'
        # 'nix build .#nixosConfigurations.iso-{amd|arm}.config.system.build.isoImage'
        iso-amd = "x86_64-linux";
        # iso-arm = "aarch64-linux";
      };

      # https://ash64.eu/blog/2022/building-custom-nixos-isos/
      # For 'nix build'
      packages."x86-64_linux".default =
        self.nixosConfigurations.iso-amd.config.system.build.isoImage;

      # packages."aarch64-linux".default =
      #   self.nixosConfigurations.iso-arm.config.system.build.isoImage;
    };
}
