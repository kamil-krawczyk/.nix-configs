# User identity used by git (author, commit signing). Set by home profiles.
{lib, ...}: {
  options.my.identity = {
    fullName = lib.mkOption {
      type = lib.types.str;
      default = "Kamil Krawczyk";
      description = "Full name used as the git author.";
    };
    email = lib.mkOption {
      type = lib.types.str;
      description = "Email used as the git author and in allowed_signers.";
    };
    sshPublicKeyFile = lib.mkOption {
      type = lib.types.path;
      description = "SSH public key used for git commit signing.";
    };
  };
}
