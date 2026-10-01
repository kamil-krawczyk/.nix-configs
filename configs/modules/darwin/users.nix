# macOS users managed by this configuration.
#
# Every entry in `my.users` gets a nix-darwin user record and a Home Manager
# configuration built from the shared home modules plus its own profiles.
# `my.primaryUser` is the user that system-wide settings (Homebrew,
# `system.defaults`, ...) are applied on behalf of.
#
# Note: nix-darwin does not create macOS accounts here; each user must
# already exist on the machine.
{
  config,
  lib,
  ...
}: let
  userSubmodule = {name, ...}: {
    options = {
      profiles = lib.mkOption {
        type = lib.types.listOf lib.types.deferredModule;
        default = [];
        description = "Home Manager profiles (or other modules) imported for this user.";
      };
      stateVersion = lib.mkOption {
        type = lib.types.str;
        description = "Home Manager state version for this user (see home.stateVersion).";
      };
      homeDirectory = lib.mkOption {
        type = lib.types.str;
        default = "/Users/${name}";
        description = "Home directory of this user.";
      };
    };
  };
in {
  options.my = {
    primaryUser = lib.mkOption {
      type = lib.types.str;
      description = "User that system-wide settings are applied on behalf of. Must be listed in `my.users`.";
    };
    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule userSubmodule);
      default = {};
      description = "Users managed on this host, keyed by account name.";
    };
  };

  config = {
    assertions = [
      {
        assertion = config.my.users ? ${config.my.primaryUser};
        message = "my.primaryUser (${config.my.primaryUser}) must be listed in my.users.";
      }
    ];

    system.primaryUser = config.my.primaryUser;

    users.users =
      lib.mapAttrs (name: user: {
        inherit name;
        home = user.homeDirectory;
        description = config.home-manager.users.${name}.my.identity.fullName;
      })
      config.my.users;

    home-manager.users =
      lib.mapAttrs (name: user: {
        imports = [../home] ++ user.profiles;
        home = {
          username = name;
          inherit (user) homeDirectory stateVersion;
        };
      })
      config.my.users;
  };
}
