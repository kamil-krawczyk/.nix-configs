{lib, ...}:
with lib; let
  userOpts = {
    name,
    config,
    ...
  }: {
    options = {
      fullName = mkOption {
        type = types.str;
        default = "Kamil Krawczyk";
      };
      email = mkOption {
        type = types.str;
        default = "kamil.krawczyk87@gmail.com";
      };
      profile = mkOption {
        type = types.str;
        default = "private";
      };
      stateVersion = mkOption {
        type = types.str;
        default = "24.11";
      };
    };
  };
in {
  options.host = {
    user = mkOption {
      type = with types; attrsOf (submodule userOpts);
      default = {};
    };
    isLinux = mkOption {
      type = types.bool;
      default = false;
    };
    wwanIf = mkOption {
      type = types.str;
    };
  };
}
