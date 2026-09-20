{
  config,
  pkgs,
  inputs,
  outputs,
  ...
}: let
  isRosetta =
    if config.nixpkgs.hostPlatform == "aarch64-darwin"
    then true
    else false;
  homeDirectory = "/Users/${config.user.name}";
in {
  imports = [
    ../options.nix
    inputs.home-manager.darwinModules.home-manager
    inputs.mac-app-util.darwinModules.default
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  ### nix, nixpkgs, home-manager ##############################################

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Determinate manages the Nix installation itself
  # (https://github.com/DeterminateSystems/nix-installer)
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = {
      inherit inputs outputs;
      userConfig = config.user;
    };
  };

  ### users ###################################################################

  system.primaryUser = config.user.name;

  users.users.${config.user.name} = {
    name = config.user.name;
    home = homeDirectory;
    description = config.user.fullName;
  };

  home-manager.users.${config.user.name} = {
    home = {
      username = config.user.name;
      homeDirectory = homeDirectory;
    };
    imports = [
      ../home/common
      ../home/users/${config.user.name}
    ];
  };

  ### shell ###################################################################

  programs.bash.enable = true;
  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];

  ### environment variables ####################################################

  environment.variables.EDITOR = "vim";

  ### system ##################################################################

  security.pam.services.sudo_local.touchIdAuth = true;

  ### homebrew ################################################################

  nix-homebrew = {
    enable = true;
    enableRosetta = isRosetta;
    user = config.user.name;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
    mutableTaps = false;
  };

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
      "android-studio"
      "flutter"
      "font-jetbrains-mono-nerd-font"
      "google-chrome"
      "kiro"
      "kiro-cli"
      "logi-options+"
      "tunnelblick"
      "wacom-tablet"
    ];
  };
}
