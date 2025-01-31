{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  users.groups = {
    libvirtd = {};
  };
}
