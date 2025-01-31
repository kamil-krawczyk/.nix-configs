{
  pkgs,
  hostConfig,
  ...
}: {
  imports = [
    ../modules/core.nix
  ];

  home = {
    username = "izunia";
    homeDirectory = "/home/izunia";
    stateVersion = hostConfig.user."izunia".stateVersion;

    sessionVariables = {
      GTK_THEME = "Colloid-Pink-Light-Compact-Catppuccin";
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Colloid-Pink-Catppuccin";
      package = pkgs.colloid-icon-theme.override {
        schemeVariants = ["catppuccin"];
        colorVariants = ["pink"];
      };
    };
    theme = {
      name = "Colloid-Pink-Light-Compact-Catppuccin";
      package = pkgs.colloid-gtk-theme.override {
        themeVariants = ["pink"];
        colorVariants = ["light"];
        sizeVariants = ["compact"];
        tweaks = ["catppuccin"];
      };
    };
    cursorTheme = {
      name = "BreezeX-RosePineDawn-Linux";
      package = pkgs.rose-pine-cursor;
    };
  };

  dconf.settings = {
    "org/gnome/shell/extensions/user-theme" = {
      name = "Colloid-Pink-Light-Compact-Catppuccin";
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "org.gnome.Console.desktop"
      ];
    };
  };
}
