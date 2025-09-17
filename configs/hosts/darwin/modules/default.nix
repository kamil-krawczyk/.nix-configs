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
    user = "kamil";
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    brews = [
      "mas"
      "btop"
      "ripgrep"
      "podman"
    ];
    casks = [
      "font-jetbrains-mono-nerd-font"
      "iterm2"
      "visual-studio-code"
      "google-chrome"
      "logi-options+"
      "wacom-tablet"
      "utm"
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
      hostConfig = config.host;
      userConfig = config.user;
    };
  };

  ### users ###################################################################

  system.primaryUser = "kamil";

  users.users.kamil = {
    name = "kamil";
    home = "/Users/kamil";
    description = "Kamil Krawczyk";
  };

  home-manager.users.kamil = {
    home = {
      username = "kamil";
      homeDirectory = "/Users/kamil";
    };
    imports = [
      ../../../home
      ../../../home/profiles/darwin
      ../../../home/profiles/${config.host.profile}
    ];
  };
}
