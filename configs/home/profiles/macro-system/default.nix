{
  config,
  pkgs,
  inputs,
  ...
}: {
  home = {
    sessionVariables = {
      EMAIL = "kkrawczyk@macrosystem.pl";
      GOPRIVATE = "git-server.macro2.local/*";
    };
  };

  programs.git = {
    extraConfig = {
      url = {
        "ssh://git-server.macro2.local/" = {
          insteadOf = "https://git-server.macro2.local/";
        };
      };
    };
  };

  ### packages ################################################################

  home.packages = with pkgs; [
    yed
  ];

  ### email ###################################################################

  home.file.".thunderbird/Kamil Krawczyk/ImapMail/243d9817e9e243fa76fb6f988a24a2934ded41d7a1679bd17ad998c0c9836107/msgFilterRules.dat".source = "${inputs.self}/configs/home/profiles/macro-system/msgFilterRules.dat";

  programs.thunderbird = {
    enable = true;
    profiles."Kamil Krawczyk" = {
      isDefault = true;
    };
    settings = {
      "mail.default_send_format" = 3;
      "mail.server.default.using_subscription" = false;
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
          "mail.identity.id_${id}.reply_on_top" = 1;
          "mail.identity.id_${id}.sig_bottom" = false;
          "mail.identity.id_${id}.htmlSigFormat" = true;
          "mail.identity.id_${id}.htmlSigText" = "${builtins.readFile "${inputs.self}/configs/home/profiles/macro-system/mail-footer.html"}";
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
