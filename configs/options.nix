{lib, ...}: {
  options = {
    host = {
      isDarwin = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      profile = lib.mkOption {
        type = lib.types.str;
        default = "private";
      };
      wwanIf = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
    };
    user = {
      email = lib.mkOption {
        type = lib.types.str;
        default = "kamil.krawczyk87@gmail.com";
      };
    };
  };
}
