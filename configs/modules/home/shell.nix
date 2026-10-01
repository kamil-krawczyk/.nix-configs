# Interactive shells (bash, zsh) and the command-line tools integrated with them.
{
  ### shells ##################################################################

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history.ignoreAllDups = true;
      shellAliases = {
        l = "eza";
        ls = "eza";
        l1 = "eza -1";
        ll = "eza -l";
        la = "eza -la";
        lt = "eza -T";
        tree = "eza -T";
      };
    };
  };

  ### direnv ##################################################################

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  ### eza #####################################################################

  programs.eza = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
    git = true;
    colors = "auto";
    icons = "auto";
    extraOptions = [
      "--group"
      "--group-directories-first"
      "--mounts"
    ];
  };

  ### fzf #####################################################################

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  ### oh-my-posh ##############################################################

  programs.oh-my-posh = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
    useTheme = "ys";
  };
}
