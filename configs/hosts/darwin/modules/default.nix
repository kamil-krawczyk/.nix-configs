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

  ### nix, nixpkgs, home-manager ##############################################

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Determinate manages the Nix installation itself
  # (https://github.com/DeterminateSystems/nix-installer)
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  # Temporary workaround for direnv build issue:
  # https://github.com/NixOS/nixpkgs/issues/502464
  nixpkgs.overlays = [
    (_: prev: {
      direnv = prev.direnv.overrideAttrs (_: {
        doCheck = false;
      });
    })
  ];

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

  ### shell ###################################################################

  programs.bash.enable = true;
  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];

  ### environment variables ####################################################

  environment.variables.EDITOR = "nvim";

  ### system ##################################################################

  security.pam.services.sudo_local.touchIdAuth = true;

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
      "bat"
      "btop"
      "cocoapods"
      "fd"
      "go"
      "gopls"
      "iproute2mac"
      "lrzsz"
      "mas"
      "node"
      "podman"
      "qemu"
      "ripgrep"
      "ruby"
      "sevenzip"
      "solargraph"
      "wget"
      "zssh"
    ];
    casks = [
      "cursor-cli"
      "cursor"
      "flutter"
      "font-jetbrains-mono-nerd-font"
      "ghostty"
      "google-chrome"
      "libreoffice"
      "logi-options+"
      "tunnelblick"
      "utm"
      "wacom-tablet"
      "xquartz"
    ];
  };
}
