# Installs the Kiro app when any user on this host enables `my.kiro.enable`,
# so a single toggle controls both the app and its configuration.
# Homebrew casks are system-wide, so the app is available to every user.
{
  config,
  lib,
  ...
}: let
  kiroEnabled = lib.any (user: user.my.kiro.enable or false) (lib.attrValues config.home-manager.users);
in {
  config = lib.mkIf kiroEnabled {
    homebrew.casks = ["kiro"];
  };
}
