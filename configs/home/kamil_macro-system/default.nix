{
  config,
  lib,
  pkgs,
  inputs,
  hostConfig,
  ...
}:
with lib; let
  user = hostConfig.user."${config.home.username}";
in {
  imports = [
    ../modules/core.nix
    ../modules/dev.nix
  ];

  home = {
    username = "kamil";
    homeDirectory = "/home/kamil";
    stateVersion = hostConfig.user."kamil".stateVersion;

    packages = with pkgs;
      []
      ++ lists.optionals (pkgs.stdenv.hostPlatform.system != "aarch64-linux") [beeper];

    sessionVariables = {
      GOPRIVATE = "git-server.macro2.local/*";
      GTK_THEME = "Colloid-Teal-Dark-Compact-Catppuccin";
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Colloid-Teal-Catppuccin";
      package = pkgs.colloid-icon-theme.override {
        schemeVariants = ["catppuccin"];
        colorVariants = ["teal"];
      };
    };
    theme = {
      name = "Colloid-Teal-Dark-Compact-Catppuccin";
      package = pkgs.colloid-gtk-theme.override {
        themeVariants = ["teal"];
        colorVariants = ["dark"];
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
      name = "Colloid-Teal-Dark-Compact-Catppuccin";
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "thunderbird.desktop"
        "beeper.desktop"
        "firefox.desktop"
        "code.desktop"
        "org.gnome.Console.desktop"
      ];
    };
  };

  programs = {
    git = {
      extraConfig = {
        url = {
          "ssh://git-server.macro2.local/" = {
            insteadOf = "https://git-server.macro2.local/";
          };
        };
      };
    };

    thunderbird = {
      enable = true;
      profiles."Kamil Krawczyk" = {
        isDefault = true;
      };
      settings = {
        "mail.default_send_format" = 3;
        "mail.server.default.using_subscription" = false;
      };
    };
  };

  accounts.email.accounts = {
    "kkrawczyk@macrosystem.pl" = {
      address = "kkrawczyk@macrosystem.pl";
      realName = "Kamil Krawczyk";
      primary = true;
      flavor = "plain";
      userName = "kkrawczyk@macrosystem.pl";
      imap = {
        host = "mail.macrosystem.pl";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "mail.macrosystem.pl";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      thunderbird = {
        enable = true;
        profiles = ["Kamil Krawczyk"];
        perIdentitySettings = id: {
          "mail.identity.id_${id}.attach_signature" = true;
          "mail.identity.id_${id}.reply_on_top" = 1;
          "mail.identity.id_${id}.sig_bottom" = false;
          "mail.identity.id_${id}.sig_file" = "${inputs.self}/configs/home/${config.home.username}_${user.profile}/mail-footer.html";
        };
      };
    };

    "kkrawczyk@macro.local" = {
      address = "kkrawczyk@macro.local";
      realName = "Kamil Krawczyk";
      primary = false;
      flavor = "plain";
      userName = "kkrawczyk@macro.local";
      imap = {
        host = "zimbra8.macro.local";
        port = 7993;
        tls.enable = true;
      };
      smtp = {
        host = "zimbra8.macro.local";
        port = 465;
        tls.enable = true;
      };
      thunderbird = {
        enable = true;
        profiles = ["Kamil Krawczyk"];
        perIdentitySettings = id: {
          "mail.identity.id_${id}.htmlSigText" = "Z uszanowaniem,\nKamil Krawczyk";
          "mail.identity.id_${id}.reply_on_top" = 1;
          "mail.identity.id_${id}.sig_bottom" = false;
        };
      };
    };
  };
}
