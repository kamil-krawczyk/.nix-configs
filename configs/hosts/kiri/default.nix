# MacBook Neo (work)
{config, ...}: {
  imports = [
    ../../modules/darwin
    ../../profiles/darwin/work.nix
  ];

  home-manager.users.${config.my.user.name} = {
    imports = [../../profiles/home/work];
    home.stateVersion = "26.11";
  };

  networking = {
    computerName = "kiri";
    hostName = config.networking.computerName;
  };

  system.stateVersion = 7;

  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.extraOptions = "extra-platforms = x86_64-darwin aarch64-darwin";
}
