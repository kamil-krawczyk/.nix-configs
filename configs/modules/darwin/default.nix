# nix-darwin modules shared by every macOS host.
{
  config,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.mac-app-util.darwinModules.default
    inputs.nix-homebrew.darwinModules.nix-homebrew

    ./users.nix
    ./kiro.nix
  ];

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
      # Homebrew is system-wide and owned by a single user.
      user = config.my.primaryUser;
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
