{config, ...}: {
  imports = [
    ../modules
  ];

  networking = {
    computerName = "konoha";
    hostName = config.networking.computerName;
  };

  system.stateVersion = 6;

  home-manager.users.${config.user.name}.home.stateVersion = "25.11";

  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.extraOptions = "extra-platforms = x86_64-darwin aarch64-darwin";
}
