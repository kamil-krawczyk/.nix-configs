{
  description = "My nix configs";

  inputs = {
    ### common ################################################################
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    systems.url = "github:nix-systems/default";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### Darwin specific #######################################################
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    mac-app-util.url = "github:hraban/mac-app-util";

    ### NixOS specific ########################################################
    hardware.url = "github:nixos/nixos-hardware/master";
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

    configureDarwin = hostname: system:
      inputs.nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {inherit self inputs outputs;};
        modules = [./configs/hosts/darwin/${hostname}];
      };

    configureNixOS = hostname: system:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit self inputs outputs;};
        modules = [./configs/hosts/nixos/${hostname}];
      };
  in {
    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    darwinConfigurations = {
      # Private MacBook Pro M4 Pro
      konoha = configureDarwin "konoha" "aarch64-darwin";
    };

    nixosConfigurations = {
      # Work desktop: AMD Ryzen 9 7900 12-Core; Gigabyte B650M DS3H
      ame = configureNixOS "ame" "x86_64-linux";

      # Work laptop: Dell Latitude E6320
      kiri = configureNixOS "kiri" "x86_64-linux";
    };
  };
}
