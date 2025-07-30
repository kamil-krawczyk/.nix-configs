{
  description = "My nix configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware/master";
    systems.url = "github:nix-systems/default";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, ...} @ inputs: let
    inherit (self) outputs;
    lib = inputs.nixpkgs.lib // inputs.home-manager.lib;

    forEachSystem = f: lib.genAttrs (import inputs.systems) (system: f pkgsFor.${system});

    pkgsFor = lib.genAttrs (import inputs.systems) (
      system:
        import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );

    configureNixOS = hostname: system:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit self inputs outputs;};
        modules = [./configs/hosts/nixos/${hostname}];
      };
  in {
    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    nixosConfigurations = {
      # Work desktop: AMD Ryzen 9 7900 12-Core; Gigabyte B650M DS3H
      ame = configureNixOS "ame" "x86_64-linux";

      # Work laptop: Dell Latitude E6320
      kiri = configureNixOS "kiri" "x86_64-linux";
    };
  };
}
