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
in {
  imports = [
    ../../../options.nix
    inputs.home-manager.darwinModules.home-manager
    inputs.mac-app-util.darwinModules.default
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  ### shell ###################################################################

  programs.bash.enable = true;
  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];

  ### editor ##################################################################

  environment.variables.EDITOR = "hx";

  ### system ##################################################################

  security.pam.services.sudo_local.touchIdAuth = true;

  ### packages ################################################################

  environment.systemPackages = with pkgs; [
    git
    helix
    tmux

    cocoapods
    ruby
  ];

  ### homebrew ################################################################

  nix-homebrew = {
    enable = true;
    enableRosetta = isRosetta;
    user = config.user.name;
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    brews = [
      "btop"
      "go"
      "iproute2mac"
      "lrzsz"
      "mas"
      "podman"
      "ripgrep"
      "wget"
      "zssh"
    ];
    casks = [
      "antigravity"
      "cursor"
      "flutter"
      "font-jetbrains-mono-nerd-font"
      "google-chrome"
      "iterm2"
      "libreoffice"
      "logi-options+"
      "tunnelblick"
      "utm"
      "wacom-tablet"
    ];
  };

  ### nix, nixpkgs, home-manager ##############################################

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Determinate manages the Nix installation itself
  # (https://github.com/DeterminateSystems/nix-installer)
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs;
      userConfig = config.user;
    };
  };

  ### users ###################################################################

  system.primaryUser = config.user.name;

  users.users.${config.user.name} = {
    name = config.user.name;
    home = config.user.homeDirectory;
    description = config.user.fullName;
  };

  home-manager.users.${config.user.name} = {
    home = {
      username = config.user.name;
      homeDirectory = config.user.homeDirectory;
    };
    imports = [
      ../../../home
      ../../../home/${config.user.name}
    ];
  };
}
