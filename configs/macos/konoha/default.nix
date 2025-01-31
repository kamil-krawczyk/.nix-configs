{
  imports = [
    ../modules/core.nix
    ../../home/kamil_private
  ];

  networking = {
    computerName = "konoha";
    hostName = "konoha";
  };

  host.user."kamil" = {};

  system.stateVersion = 6;

  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.extraOptions = "extra-platforms = x86_64-darwin aarch64-darwin";
}
