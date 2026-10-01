# Kiro user-level configuration (steering rules).
# On nix-darwin hosts, enabling this also installs the Kiro cask
# (see configs/modules/darwin/kiro.nix).
{
  config,
  lib,
  ...
}: {
  options.my.kiro.enable = lib.mkEnableOption "Kiro configuration";

  config = lib.mkIf config.my.kiro.enable {
    home.file.".kiro/steering/language-policy.md".source = ./steering/language-policy.md;
  };
}
