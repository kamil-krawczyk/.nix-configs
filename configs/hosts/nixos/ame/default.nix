{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../modules
    ../modules/profiles/macro-system

    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-cpu-amd-raphael-igpu
    inputs.hardware.nixosModules.common-cpu-amd-zenpower
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.gigabyte-b650
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices."luks-d4eedf8f-5a2e-4d20-9b7e-65e7b9370bd5".device = "/dev/disk/by-uuid/d4eedf8f-5a2e-4d20-9b7e-65e7b9370bd5";
  };

  networking.hostName = "ame";

  host = {
    isDarwin = false;
    profile = "macro-system";
    wwanIf = "wlp15s0u6";
  };

  user.email = "kkrawczyk@macrosystem.pl";

  system.stateVersion = "25.05";
}
