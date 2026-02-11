{
  description = "My nix configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    systems.url = "github:nix-systems/default";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
  in {
    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    darwinConfigurations = {
      # MacBook Pro M4 Pro
      konoha = configureDarwin "konoha" "aarch64-darwin";
    };
  };
}
