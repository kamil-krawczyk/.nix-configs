{config, ...}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  imports = [
    ./hardware-configuration.nix
    ../modules/core.nix
    ../modules/podman.nix
    ../modules/macro-system/vpn.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "taki";

  users.users.kamil = {
    isNormalUser = true;
    description = "Kamil Krawczyk";
    extraGroups =
      [
        "networkmanager"
        "wheel"
        "lp"
        "scanner"
      ]
      ++ ifTheyExist [
        "podman"
      ];
  };

  host = {
    user."kamil" = {
      email = "kkrawczyk@macrosystem.pl";
      profile = "macro-system";
    };
    isLinux = true;
  };

  home-manager.users.kamil = import ../../home/kamil_macro-system;

  system.stateVersion = "24.11";
}
