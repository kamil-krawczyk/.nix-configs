{
  config,
  inputs,
  pkgs,
  ...
}: let
  secretsPath = "${builtins.toString inputs.self}/configs/hosts/nixos/modules/profiles/macro-system/secrets.yaml";
  wwanIf = config.host.wwanIf;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  networking.networkmanager.plugins = [
    pkgs.networkmanager-openvpn
  ];

  environment = {
    systemPackages = with pkgs; [
      networkmanagerapplet
      openfortivpn
      openfortivpn-webview

      ### custom scripts ###

      (writeScriptBin "vpn-skmwaw-svpncookie" ''
        #!/bin/sh
        ${pkgs.openfortivpn-webview}/bin/openfortivpn-webview "vpn.skm.warszawa.pl/remote/saml/start?realm="
      '')

      (writeScriptBin "vpn-skmwaw-connect" ''
        #!/bin/sh
        sudo ${pkgs.openfortivpn}/bin/openfortivpn vpn.skm.warszawa.pl:443 --no-dns -u kkrawczyk@macrosystem.pl --cookie=SVPNCOOKIE="$1"
      '')
    ];
  };

  sops = {
    defaultSopsFile = secretsPath;
    secrets = {
      "wireless/farbiarska" = {};
      "vpn/farbiarska/credentials" = {};
      "vpn/farbiarska/ca" = {};
      "vpn/farbiarska/cert" = {};
      "vpn/farbiarska/key" = {};
    };
  };

  ### networking ##############################################################

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [
      config.sops.secrets."wireless/farbiarska".path
      config.sops.secrets."vpn/farbiarska/credentials".path
    ];

    # Convert .nmconnection files into nix code with use of https://github.com/janik-haag/nm2nix
    # sudo su -c "cd /etc/NetworkManager/system-connections && nix --extra-experimental-features 'nix-command flakes' run github:Janik-Haag/nm2nix"

    profiles = {
      ### wireless ############################################################

      "FARBIARSKA-3" = {
        connection = {
          id = "FARBIARSKA-3";
          interface-name = wwanIf;
          type = "wifi";
          uuid = "bb051ae7-a1d8-400d-ac84-04d05db5280b";
        };
        ipv4 = {method = "auto";};
        ipv6 = {
          addr-gen-mode = "default";
          method = "disabled";
        };
        proxy = {};
        wifi = {
          mode = "infrastructure";
          ssid = "FARBIARSKA-3";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$FARBIARSKA_3";
        };
      };

      "FARBIARSKA-4" = {
        connection = {
          id = "FARBIARSKA-4";
          interface-name = wwanIf;
          type = "wifi";
          uuid = "d36692a3-c5e8-460c-9b20-c3e44e214d33";
        };
        ipv4 = {method = "auto";};
        ipv6 = {
          addr-gen-mode = "default";
          method = "disabled";
        };
        proxy = {};
        wifi = {
          mode = "infrastructure";
          ssid = "FARBIARSKA-4";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$FARBIARSKA_4";
        };
      };

      "FARBIARSKA-6-2.4GHz" = {
        connection = {
          id = "FARBIARSKA-6-2.4GHz";
          interface-name = wwanIf;
          type = "wifi";
          uuid = "c0545f85-abc2-409e-b8c5-abe9ef423a5a";
        };
        ipv4 = {method = "auto";};
        ipv6 = {
          addr-gen-mode = "default";
          method = "disabled";
        };
        proxy = {};
        wifi = {
          mode = "infrastructure";
          ssid = "FARBIARSKA-6-2.4GHz";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$FARBIARSKA_6_2";
        };
      };

      "FARBIARSKA-6-5GHz" = {
        connection = {
          id = "FARBIARSKA-6-5GHz";
          interface-name = wwanIf;
          type = "wifi";
          uuid = "9fc2dc3f-a896-415f-984a-e229553e0a7f";
        };
        ipv4 = {method = "auto";};
        ipv6 = {
          addr-gen-mode = "default";
          method = "disabled";
        };
        proxy = {};
        wifi = {
          mode = "infrastructure";
          ssid = "FARBIARSKA-6-5GHz";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$FARBIARSKA_6_5";
        };
      };

      "FARBIARSKA-7-2.4GHz" = {
        connection = {
          id = "FARBIARSKA-7-2.4GHz";
          interface-name = wwanIf;
          type = "wifi";
          uuid = "0d5d3603-0d47-49b7-a441-c5cc16d75bab";
        };
        ipv4 = {method = "auto";};
        ipv6 = {
          addr-gen-mode = "default";
          method = "disabled";
        };
        proxy = {};
        wifi = {
          mode = "infrastructure";
          ssid = "FARBIARSKA-7-2.4GHz";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$FARBIARSKA_7_2";
        };
      };

      "FARBIARSKA-7-5GHz" = {
        connection = {
          id = "FARBIARSKA-7-5GHz";
          interface-name = wwanIf;
          type = "wifi";
          uuid = "9ccde1a1-0d3b-46b3-a3de-bcbf5a01588e";
        };
        ipv4 = {method = "auto";};
        ipv6 = {
          addr-gen-mode = "default";
          method = "disabled";
        };
        proxy = {};
        wifi = {
          mode = "infrastructure";
          ssid = "FARBIARSKA-7-5GHz";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$FARBIARSKA_7_5";
        };
      };

      "FARBIARSKA-14-2.4GHz" = {
        connection = {
          id = "FARBIARSKA-14-2.4GHz";
          interface-name = wwanIf;
          type = "wifi";
          uuid = "787d00f8-f80c-4210-9a61-a87ebd08747d";
        };
        ipv4 = {method = "auto";};
        ipv6 = {
          addr-gen-mode = "default";
          method = "disabled";
        };
        proxy = {};
        wifi = {
          mode = "infrastructure";
          ssid = "FARBIARSKA-14-2.4GHz";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$FARBIARSKA_14_2";
        };
      };

      "FARBIARSKA-14-5GHz" = {
        connection = {
          id = "FARBIARSKA-14-5GHz";
          interface-name = wwanIf;
          type = "wifi";
          uuid = "d1272b74-9007-4c7e-8976-ba466312edda";
        };
        ipv4 = {method = "auto";};
        ipv6 = {
          addr-gen-mode = "default";
          method = "disabled";
        };
        proxy = {};
        wifi = {
          mode = "infrastructure";
          ssid = "FARBIARSKA-14-5GHz";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$FARBIARSKA_14_5";
        };
      };

      "FARBIARSKA-15-2.4GHz" = {
        connection = {
          id = "FARBIARSKA-15-2.4GHz";
          interface-name = wwanIf;
          type = "wifi";
          uuid = "bdbabf49-f1f2-4dc3-a199-f9ad0f5dfae1";
        };
        ipv4 = {method = "auto";};
        ipv6 = {
          addr-gen-mode = "default";
          method = "disabled";
        };
        proxy = {};
        wifi = {
          mode = "infrastructure";
          ssid = "FARBIARSKA-15-2.4GHz";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$FARBIARSKA_15_2";
        };
      };

      "FARBIARSKA-15-5GHz" = {
        connection = {
          id = "FARBIARSKA-15-5GHz";
          interface-name = wwanIf;
          type = "wifi";
          uuid = "cb6311bd-7f19-472c-a344-968975c96678";
        };
        ipv4 = {method = "auto";};
        ipv6 = {
          addr-gen-mode = "default";
          method = "disabled";
        };
        proxy = {};
        wifi = {
          mode = "infrastructure";
          ssid = "FARBIARSKA-15-5GHz";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$FARBIARSKA_15_5";
        };
      };

      "Gronostaj-1-2.4GHz" = {
        connection = {
          id = "Gronostaj-1-2.4GHz";
          interface-name = wwanIf;
          type = "wifi";
          uuid = "254dc376-1074-43ae-b6ed-fb0a49a8c0ea";
        };
        ipv4 = {method = "auto";};
        ipv6 = {
          addr-gen-mode = "default";
          method = "disabled";
        };
        proxy = {};
        wifi = {
          mode = "infrastructure";
          ssid = "Gronostaj-1-2.4GHz";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$GRONOSTAJ_1_2";
        };
      };

      "Gronostaj-1-5GHz" = {
        connection = {
          id = "Gronostaj-1-5GHz";
          interface-name = wwanIf;
          type = "wifi";
          uuid = "cae3df1a-a2c1-43f2-ae1b-581878376085";
        };
        ipv4 = {method = "auto";};
        ipv6 = {
          addr-gen-mode = "default";
          method = "disabled";
        };
        proxy = {};
        wifi = {
          mode = "infrastructure";
          ssid = "Gronostaj-1-5GHz";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$GRONOSTAJ_1_5";
        };
      };

      "Gronostaj-2-2.4GHz" = {
        connection = {
          id = "Gronostaj-2-2.4GHz";
          interface-name = wwanIf;
          type = "wifi";
          uuid = "6191f8fa-6682-49f2-a0b1-c323292addee";
        };
        ipv4 = {method = "auto";};
        ipv6 = {
          addr-gen-mode = "default";
          method = "disabled";
        };
        proxy = {};
        wifi = {
          mode = "infrastructure";
          ssid = "Gronostaj-2-2.4GHz";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$GRONOSTAJ_2_2";
        };
      };

      "Gronostaj-2-5GHz" = {
        connection = {
          id = "Gronostaj-2-5GHz";
          interface-name = wwanIf;
          type = "wifi";
          uuid = "25b6e779-330f-44e9-a7dc-9801c2239b45";
        };
        ipv4 = {method = "auto";};
        ipv6 = {
          addr-gen-mode = "default";
          method = "disabled";
        };
        proxy = {};
        wifi = {
          mode = "infrastructure";
          ssid = "Gronostaj-2-5GHz";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$GRONOSTAJ_2_5";
        };
      };

      "Konferencja" = {
        connection = {
          id = "Konferencja";
          interface-name = wwanIf;
          type = "wifi";
          uuid = "9abcc823-45a4-4b3a-9bf8-b7f9bdce36e3";
        };
        ipv4 = {method = "auto";};
        ipv6 = {
          addr-gen-mode = "default";
          method = "disabled";
        };
        proxy = {};
        wifi = {
          mode = "infrastructure";
          ssid = "Konferencja";
        };
        wifi-security = {
          auth-alg = "open";
          key-mgmt = "wpa-psk";
          psk = "$Konferencja";
        };
      };

      ### vpn #####################################################################

      "kkrawczyk@pluton" = {
        connection = {
          autoconnect = "false";
          id = "kkrawczyk@pluton";
          type = "vpn";
          uuid = "cc453766-0940-447f-b02d-866fd93fa240";
        };
        ipv4 = {
          method = "auto";
          never-default = "true";
        };
        ipv6 = {
          addr-gen-mode = "stable-privacy";
          method = "ignore";
        };
        proxy = {};
        vpn = {
          allow-compression = "asym";
          auth = "SHA512";
          ca = config.sops.secrets."vpn/farbiarska/ca".path;
          cert = config.sops.secrets."vpn/farbiarska/cert".path;
          cert-pass-flags = "0";
          challenge-response-flags = "2";
          cipher = "AES-256-CBC";
          comp-lzo = "adaptive";
          connection-type = "password-tls";
          data-ciphers = "AES-256-CBC";
          dev = "tun";
          dev-type = "tun";
          key = config.sops.secrets."vpn/farbiarska/key".path;
          password-flags = "0";
          proto-tcp = "yes";
          remote = "$REMOTE";
          reneg-seconds = "0";
          service-type = "org.freedesktop.NetworkManager.openvpn";
          tls-cipher = "$TLS_CIPHER";
          username = "$USERNAME";
          verify-x509-name = "$X509_NAME";
        };
        vpn-secrets = {password = "$PASSWORD";};
      };
    };
  };
}
