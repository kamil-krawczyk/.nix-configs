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
    ../modules/macro-system/vpn.nix
    ../modules/macro-system/wireless.nix

    inputs.hardware.nixosModules.common-cpu-intel-cpu-only
    inputs.hardware.nixosModules.common-gpu-intel-sandy-bridge
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices."luks-ec48df08-6ca8-4d79-a6ae-685ea9f925f0".device = "/dev/disk/by-uuid/ec48df08-6ca8-4d79-a6ae-685ea9f925f0";
    kernelParams = [
      "b43.allhwsupport=1"
    ];
  };

  networking = {
    hostName = "kiri";
    enableB43Firmware = true;
  };

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
    wwanIf = "wlp2s0b1";
  };

  home-manager.users.kamil = import ../../home/kamil_macro-system;

  system.stateVersion = "24.11";
}
