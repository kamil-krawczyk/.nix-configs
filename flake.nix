{
  description = "Determinate Systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+ssh://git@github.com/kamil-krawczyk/.secrets-nix.git?ref=main&shallow=1";
      flake = false;
    };

    ### MacOS specific ########################################################
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
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
    hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = {self, ...} @ inputs: let
    inherit (self) outputs;

    configureDarwin = hostname: system:
      inputs.nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {inherit self inputs outputs;};
        modules = [./configs/macos/${hostname}];
      };

    configureNixOS = hostname: system:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit self inputs outputs;};
        modules = [./configs/nixos/${hostname}];
      };

    systems = ["aarch64-darwin" "x86_64-linux"];

    forEachSystem = pkgs:
      inputs.nixpkgs.lib.genAttrs systems
      (system: pkgs (import inputs.nixpkgs {inherit system;}));
  in {
    darwinConfigurations = {
      # Private MacBook Pro M4 Pro
      konoha = configureDarwin "konoha" "aarch64-darwin";
    };

    nixosConfigurations = {
      # My wife's private laptop: Asus R541U
      suna = configureNixOS "suna" "x86_64-linux";

      # Work custom desktop: Gigabyte B650M DS3H; AMD Ryzen 9 7900
      ame = configureNixOS "ame" "x86_64-linux";

      # Work laptop: Dell Latitude E6320
      kiri = configureNixOS "kiri" "x86_64-linux";
    };

    formatter = forEachSystem (pkgs: pkgs.alejandra);
  };
}
