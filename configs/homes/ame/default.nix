# ame: work PC running Ubuntu, managed by standalone Home Manager.
{
  imports = [
    ../../modules/home
    ../../profiles/home/work
  ];

  home = {
    username = "kamil";
    homeDirectory = "/home/kamil";
    stateVersion = "26.11";
  };

  # Integration with Ubuntu as a non-NixOS host (XDG data dirs, nix in PATH, etc.).
  targets.genericLinux.enable = true;

  # Provide the `home-manager` CLI for subsequent switches.
  programs.home-manager.enable = true;
}
