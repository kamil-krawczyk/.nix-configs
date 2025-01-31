{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../modules/core.nix
    ../modules/auto-upgrade.nix

    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel-kaby-lake
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices."luks-1097b78e-1436-4b24-b6d4-feaf45da0706".device = "/dev/disk/by-uuid/1097b78e-1436-4b24-b6d4-feaf45da0706";
  };

  networking.hostName = "suna";

  users.users.izunia = {
    isNormalUser = true;
    description = "Izabela Krawczyk";
    extraGroups = [
      "networkmanager"
      "wheel"
      "lp"
      "scanner"
    ];
  };

  host = {
    user."izunia" = {
      fullName = "Izabela Krawczyk";
      email = "izabela.krawczyk87@gmail.com";
    };
    isLinux = true;
    wwanIf = "wlp3s0";
  };

  home-manager.users.izunia = import ../../home/izunia_private;

  system.stateVersion = "24.11";
}
