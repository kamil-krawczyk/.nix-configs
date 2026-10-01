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

    mac-app-util = {
      url = "github:hraban/mac-app-util";
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

    configureDarwin = hostname: system:
      inputs.nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {inherit self inputs outputs;};
        modules = [./configs/hosts/${hostname}];
      };

    # `name` is "<user>@<hostname>", matching the directory in configs/homes
    # and the name `home-manager switch` looks up by default.
    configureHome = name: system:
      lib.homeManagerConfiguration {
        pkgs = pkgsFor.${system};
        extraSpecialArgs = {inherit self inputs outputs;};
        modules = [./configs/homes/${name}];
      };
  in {
    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    darwinConfigurations = {
      # MacBook Pro M4 Pro (personal)
      konoha = configureDarwin "konoha" "aarch64-darwin";

      # MacBook Neo (work)
      kiri = configureDarwin "kiri" "aarch64-darwin";
    };

    homeConfigurations = {
      # Work PC, Ubuntu (standalone Home Manager)
      "kamil@ame" = configureHome "kamil@ame" "x86_64-linux";
    };
  };
}
