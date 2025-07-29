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
      homeDirectory = lib.mkOption {
        type = lib.types.str;
        default = "/Users/kamil";
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "kamil.krawczyk87@gmail.com";
      };
    };
  };
}
