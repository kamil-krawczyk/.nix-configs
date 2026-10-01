# MacBook Pro M4 Pro (personal)
{config, ...}: {
  imports = [
    ../../modules/darwin
    ../../profiles/darwin/personal.nix
  ];

  my.primaryUser = "kamil";

  my.users.kamil = {
    profiles = [../../profiles/home/personal];
    stateVersion = "25.11";
  };

  networking = {
    computerName = "konoha";
    hostName = config.networking.computerName;
  };

  system.stateVersion = 6;

  nixpkgs.hostPlatform = "aarch64-darwin";
}
