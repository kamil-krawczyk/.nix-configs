{
  config,
  inputs,
  ...
}: let
  secretsPath = "${builtins.toString inputs.secrets}/macro-system/secrets.yaml";
in {
  sops = {
    defaultSopsFile = secretsPath;
    secrets = {
      "vpn/pluton/credentials" = {};
      "vpn/pluton/ca" = {};
      "vpn/pluton/cert" = {};
      "vpn/pluton/key" = {};
    };
  };

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [config.sops.secrets."vpn/pluton/credentials".path];
    # Convert .nmconnection files into nix code with use of https://github.com/janik-haag/nm2nix
    # sudo su -c "cd /etc/NetworkManager/system-connections && nix --extra-experimental-features 'nix-command flakes' run github:Janik-Haag/nm2nix"
    profiles = {
      "vpn@macro-system" = {
        connection = {
          autoconnect = "false";
          id = "vpn@macro-system";
          type = "vpn";
          uuid = "bacca0a4-25a9-4733-853d-40dcd53ea6eb";
        };
        ipv4 = {
          method = "auto";
          never-default = "true";
        };
        ipv6 = {
          addr-gen-mode = "default";
          method = "disabled";
        };
        proxy = {};
        vpn = {
          allow-compression = "asym";
          auth = "$AUTH";
          ca = config.sops.secrets."vpn/pluton/ca".path;
          cert = config.sops.secrets."vpn/pluton/cert".path;
          cert-pass-flags = "0";
          data-ciphers = "$CIPHER";
          comp-lzo = "adaptive";
          connection-type = "password-tls";
          dev = "tun";
          dev-type = "tun";
          key = config.sops.secrets."vpn/pluton/key".path;
          password-flags = "0";
          proto-tcp = "yes";
          remote = "$REMOTE";
          reneg-seconds = "0";
          service-type = "org.freedesktop.NetworkManager.openvpn";
          tls-cipher = "$TLS_CIPHER";
          username = "kkrawczyk";
          verify-x509-name = "subject:C=pl, L=Warszawa, O=Macro-System, CN=PLUTON, emailAddress=jacekd@macrosystem.pl";
        };
        vpn-secrets = {password = "$PASSWORD";};
      };
    };
  };
}
