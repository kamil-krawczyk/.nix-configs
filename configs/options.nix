{lib, ...}: {
  options = {
    user = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "kamil";
      };
      fullName = lib.mkOption {
        type = lib.types.str;
        default = "Kamil Krawczyk";
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "kamil.krawczyk87@gmail.com";
      };
    };
  };
}
