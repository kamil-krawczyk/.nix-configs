{lib, ...}: {
  options = {
    host = {
      profile = lib.mkOption {
        type = lib.types.str;
        default = "private";
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
