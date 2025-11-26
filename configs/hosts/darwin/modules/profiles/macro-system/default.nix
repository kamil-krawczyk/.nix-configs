{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      ### custom scripts ###
      (writeScriptBin "vpn-skmwaw-connect" ''
        #!/bin/sh
        sudo ${pkgs.openfortivpn}/bin/openfortivpn vpn.skm.warszawa.pl:443 --no-dns -u kkrawczyk@macrosystem.pl --cookie=SVPNCOOKIE="$1"
      '')
    ];
  };

  homebrew = {
    casks = [
      "tunnelblick"
    ];
  };
}
