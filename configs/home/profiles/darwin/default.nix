{config, ...}: {
  home.sessionPath = [
    "${config.home.homeDirectory}/.flutter/bin"
  ];
}
