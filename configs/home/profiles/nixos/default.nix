{pkgs, ...}: {
  home.packages = with pkgs; [
    hunspellDicts.en_US
    hunspellDicts.pl_PL
    libreoffice
    google-chrome
  ];

  programs.firefox.enable = true;

  dconf.settings = {
    "org/gnome/desktop/media-handling" = {
      automount = false;
      automount-open = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/mutter" = {
      center-new-windows = true;
      dynamic-workspaces = true;
      edge-tiling = true;
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "caffeine@patapon.info"
      ];
    };
    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "nothing";
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "nothing";
    };
    "org/gnome/system/location" = {
      enabled = true;
    };
    "org/gnome/Console" = {
      ignore-scrollback-limit = true;
      theme = "night";
    };
  };

  fonts.fontconfig.enable = true;
}
