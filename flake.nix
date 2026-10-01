{
  description = "My nix configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

    # Platforms supported by this flake. x86_64-darwin is left out, because
    # nixpkgs no longer supports it.
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];

    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});

    pkgsFor = lib.genAttrs systems (
      system:
        import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );

    # Extra arguments passed to every module (nix-darwin and Home Manager).
    # The flake itself is available as `inputs.self`.
    specialArgs = {inherit inputs outputs;};

    # The platform comes from `nixpkgs.hostPlatform` in the host file.
    configureDarwin = hostname:
      inputs.nix-darwin.lib.darwinSystem {
        inherit specialArgs;
        modules = [./configs/hosts/${hostname}];
      };

    # `name` is "<user>@<hostname>", matching the directory in configs/homes
    # and the name `home-manager switch` looks up by default.
    configureHome = name: system:
      lib.homeManagerConfiguration {
        pkgs = pkgsFor.${system};
        extraSpecialArgs = specialArgs;
        modules = [./configs/homes/${name}];
      };
  in {
    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    darwinConfigurations = {
      # MacBook Pro M4 Pro (personal)
      konoha = configureDarwin "konoha";

      # MacBook Neo (work)
      kiri = configureDarwin "kiri";
    };

    homeConfigurations = {
      # Work PC, Ubuntu (standalone Home Manager)
      "kamil@ame" = configureHome "kamil@ame" "x86_64-linux";
    };
  };
}
