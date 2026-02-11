{
  config,
  pkgs,
  inputs,
  hostConfig,
  userConfig,
  ...
}: let
  sshPubKeyPath = "${inputs.self}/configs/home/profiles/${hostConfig.profile}/id_ed25519.pub";
in {
  ### shell ###################################################################

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

    eza = {
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

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    oh-my-posh = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = true;
      useTheme = "slimfat";
    };
  };

  ### helix ###################################################################

  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "base16_default";
      editor = {
        auto-format = true;
        bufferline = "multiple";
        color-modes = true;
        completion-replace = true;
        cursorline = true;
        line-number = "relative";
        rulers = [79];
      };
      editor.whitespace.characters = {
        space = "·";
        nbsp = "⍽";
        tab = "→";
        newline = "⏎";
        tabpad = "·";
      };
      editor.indent-guides = {
        render = true;
        character = "┊";
        skip-levels = 0;
      };
      editor.soft-wrap = {
        enable = true;
      };
      editor.file-picker = {
        hidden = false;
        git-ignore = false;
      };
      editor.statusline = {
        left = [
          "mode"
          "spacer"
          "version-control"
          "spacer"
          "separator"
          "file-name"
          "file-modification-indicator"
        ];
        right = [
          "spinner"
          "spacer"
          "workspace-diagnostics"
          "separator"
          "spacer"
          "diagnostics"
          "position"
          "file-encoding"
          "file-line-ending"
          "file-type"
        ];
        separator = "╎";
        mode.normal = "NORMAL";
        mode.insert = "INSERT";
        mode.select = "SELECT";
      };
      keys.normal = {
        esc = ["collapse_selection" "keep_primary_selection" ":w"];
      };
      keys.normal.g = {
        q = ":bc";
        Q = ":bc!";
      };
    };
  };

  ### git #####################################################################

  home.file = {
    ".ssh/allowed_signers".text = "${userConfig.email} namespaces=\"git\" ${builtins.readFile "${sshPubKeyPath}"}";
    ".config/git/config.private".text = "[user]\n\tname = \"Kamil Krawczyk\"\n\temail = \"kamil.krawczyk87@gmail.com\"\n";
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Kamil Krawczyk";
        email = userConfig.email;
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
    includes = [
      {
        path = "~/.config/git/config.private";
        condition = "gitdir:~/.nix-configs/";
      }
    ];
  };

  ### delta ###################################################################

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
    };
  };

  ### direnv ##################################################################

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  ### other packages ##########################################################
  home.packages = with pkgs; [
    pywal
  ];
}
