# nix-darwin modules shared by every macOS host.
{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: let
  userName = config.my.user.name;
  homeDirectory = "/Users/${userName}";
  hmUser = config.home-manager.users.${userName};
in {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.mac-app-util.darwinModules.default
    inputs.nix-homebrew.darwinModules.nix-homebrew

    ./kiro.nix
  ];

  options.my.user.name = lib.mkOption {
    type = lib.types.str;
    default = "kamil";
    description = "Primary macOS user managed by this configuration.";
  };

  config = {
    ### nix, nixpkgs, home-manager ############################################

    system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    # Determinate manages the Nix installation itself
    # (https://github.com/DeterminateSystems/nix-installer)
    nix.enable = false;

    nixpkgs.config.allowUnfree = true;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
      extraSpecialArgs = {inherit inputs outputs;};
    };

    ### users #################################################################

    system.primaryUser = userName;

    users.users.${userName} = {
      name = userName;
      home = homeDirectory;
      description = hmUser.my.identity.fullName;
    };

    home-manager.users.${userName} = {
      imports = [../home];
      home = {
        username = userName;
        homeDirectory = homeDirectory;
      };
    };

    ### shell #################################################################

    programs.bash.enable = true;
    programs.zsh.enable = true;
    environment.shells = [pkgs.zsh];

    ### environment variables #################################################

    environment.variables.EDITOR = "vim";

    ### system ################################################################

    security.pam.services.sudo_local.touchIdAuth = true;

    ### homebrew ##############################################################

    nix-homebrew = {
      enable = true;
      enableRosetta = config.nixpkgs.hostPlatform == "aarch64-darwin";
      user = userName;
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      };
      mutableTaps = false;
    };

    # Profiles and hosts append their own entries to `homebrew.casks`.
    homebrew = {
      enable = true;
      taps = builtins.attrNames config.nix-homebrew.taps;
      onActivation = {
        cleanup = "zap";
        autoUpdate = true;
        upgrade = true;
      };
      brews = [
        "btop"
        "cocoapods"
        "fd"
        "iproute2mac"
        "lrzsz"
        "mas"
        "podman"
        "ripgrep"
        "sevenzip"
        "wget"
        "zssh"
      ];
      casks = [
        "flutter"
        "font-jetbrains-mono-nerd-font"
        "tunnelblick"
      ];
    };
  };
}
