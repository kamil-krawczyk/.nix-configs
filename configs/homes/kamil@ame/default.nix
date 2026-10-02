# kamil on ame: work PC running Ubuntu, managed by standalone Home Manager.
# Each user on a Linux machine has their own `configs/homes/<user>@<host>`
# and activates it from their own account.
{config, ...}: {
  imports = [
    ../../modules/home
    ../../profiles/home/work
  ];

  home = {
    username = "kamil";
    homeDirectory = "/home/kamil";
    stateVersion = "26.11";

    # Flutter SDK installed by hand outside of Nix.
    sessionPath = [
      "${config.home.homeDirectory}/.develop/flutter/bin"
    ];
  };

  # Integration with Ubuntu as a non-NixOS host (XDG data dirs, nix in PATH, etc.).
  targets.genericLinux.enable = true;

  # Provide the `home-manager` CLI for subsequent switches.
  programs.home-manager.enable = true;
}
