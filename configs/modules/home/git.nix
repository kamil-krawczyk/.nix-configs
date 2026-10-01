{config, ...}: let
  identity = config.my.identity;
in {
  home.file.".ssh/allowed_signers".text = "${identity.email} namespaces=\"git\" ${builtins.readFile identity.sshPublicKeyFile}";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = identity.fullName;
        email = identity.email;
      };
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";
    };
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
    };
  };
}
