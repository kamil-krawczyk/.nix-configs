# MacBook Neo (work)
{config, ...}: {
  imports = [
    ../../modules/darwin
    ../../profiles/darwin/work.nix
  ];

  my.primaryUser = "kamil";

  my.users.kamil = {
    profiles = [../../profiles/home/work];
    stateVersion = "26.11";
  };

  networking = {
    computerName = "kiri";
    hostName = config.networking.computerName;
  };

  system.stateVersion = 7;

  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.extraOptions = "extra-platforms = x86_64-darwin aarch64-darwin";
}
