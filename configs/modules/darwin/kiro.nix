# Installs the Kiro app when the primary user's home enables `my.kiro.enable`,
# so a single toggle controls both the app and its configuration.
{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.home-manager.users.${config.my.user.name}.my.kiro.enable {
    homebrew.casks = ["kiro"];
  };
}
