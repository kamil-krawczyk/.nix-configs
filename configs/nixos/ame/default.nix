{
  config,
  inputs,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  imports = [
    ./hardware-configuration.nix
    ../modules/core.nix
    ../modules/podman.nix
    ../modules/libvirtd.nix
    ../modules/macro-system/vpn.nix
    ../modules/macro-system/wireless.nix

    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-cpu-amd-raphael-igpu
    inputs.hardware.nixosModules.common-cpu-amd-zenpower
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "ame";

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
        "libvirtd"
        "podman"
      ];
  };

  host = {
    user."kamil" = {
      email = "kkrawczyk@macrosystem.pl";
      profile = "macro-system";
    };
    isLinux = true;
    wwanIf = "wlp18s0u1u3";
  };

  home-manager.users.kamil = import ../../home/kamil_macro-system;

  system.stateVersion = "24.11";
}
