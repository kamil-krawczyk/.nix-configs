{
  config,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../modules
    ../modules/profiles/macro-system

    inputs.hardware.nixosModules.common-cpu-intel-cpu-only
    inputs.hardware.nixosModules.common-gpu-intel-sandy-bridge
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices."luks-01f1d729-c3f4-423b-b302-83cca8cecaae".device = "/dev/disk/by-uuid/01f1d729-c3f4-423b-b302-83cca8cecaae";
    kernelParams = ["b43.allhwsupport=1"];
  };

  networking = {
    hostName = "kiri";
    enableB43Firmware = true;
  };

  host = {
    isDarwin = false;
    profile = "macro-system";
    wwanIf = "wlp2s0b1";
  };

  user.email = "kkrawczyk@macrosystem.pl";

  system.stateVersion = "25.05";
}
