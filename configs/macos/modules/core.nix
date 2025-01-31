{
  config,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ../../options.nix
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
    extraSpecialArgs = {
      inherit inputs outputs;
      hostConfig = config.host;
    };
  };

  ### shell ###################################################################

  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];

  ### editor ##################################################################

  environment.variables = {
    EDITOR = "hx";
  };

  ### security, system ########################################################

  security.pam.enableSudoTouchIdAuth = true;

  system.startup.chime = false;

  ### packages ################################################################

  environment.systemPackages = with pkgs; [
    age
    sops
    ssh-to-age

    helix
  ];

  ### homebrew ################################################################

  nix-homebrew.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    brews = [
      "mas"
    ];
    casks = [
      "font-jetbrains-mono-nerd-font"
    ];
  };
}
