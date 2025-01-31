{hostConfig, ...}: {
  imports = [
    ../modules/core.nix
  ];

  home = {
    username = "izunia";
    homeDirectory = "/home/izunia";
    stateVersion = hostConfig.user."izunia".stateVersion;
  };

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "org.gnome.Console.desktop"
      ];
    };
  };
}
