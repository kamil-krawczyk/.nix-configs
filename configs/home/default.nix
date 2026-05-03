{
  config,
  pkgs,
  inputs,
  userConfig,
  ...
}: let
  sshPubKeyPath = "${inputs.self}/configs/home/${userConfig.name}/id_ed25519.pub";
  cursorSettingsPath =
    if pkgs.stdenv.isDarwin
    then "Library/Application Support/Cursor/User/settings.json"
    else ".config/Cursor/User/settings.json";
in {
  ### session #################################################################

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

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
  };

  ### direnv ##################################################################

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  ### eza ######################################################################

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

  ### oh-my-posh ###############################################################

  programs.oh-my-posh = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
    useTheme = "ys";
  };

  ### git #####################################################################

  home.file.".ssh/allowed_signers".text = "${userConfig.email} namespaces=\"git\" ${builtins.readFile "${sshPubKeyPath}"}";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = userConfig.fullName;
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

  ### neovim ##################################################################

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withRuby = false;
    withPython3 = false;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter
      nvim-lspconfig
      nvim-web-devicons
      bufferline-nvim
      nvim-tree-lua
      indent-blankline-nvim
    ];
    # Homebrew packages: gopls, solargraph, node, Dart SDK (Flutter cask bundles
    # Dart). Neovim uses Node from Homebrew; dartls uses `dart` on PATH.
    extraPackages = with pkgs; [
      pyright
      nixd
      clang-tools
      marksman
      bash-language-server
      typescript-language-server
      vscode-langservers-extracted
    ];
    extraConfig = ''
      set number
      set relativenumber
      set foldmethod=expr
      set foldexpr=nvim_treesitter#foldexpr()
      set foldlevelstart=99
      set nospell
      set spelllang=en,pl
    '';
    initLua = ''
      local is_vscode = vim.g.vscode == 1 or vim.g.vscode == true
      if is_vscode then
        return
      end

      local function setup_lsp(server, opts)
        local ok_config = pcall(vim.lsp.config, server, opts or {})
        local ok_enable = pcall(vim.lsp.enable, server)
        if not (ok_config and ok_enable) then
          vim.notify("LSP server not available: " .. server, vim.log.levels.WARN)
        end
        return ok_config and ok_enable
      end

      setup_lsp("gopls")
      setup_lsp("nixd")
      setup_lsp("dartls")
      setup_lsp("pyright")
      setup_lsp("solargraph")
      setup_lsp("clangd")
      setup_lsp("marksman")
      if not setup_lsp("ts_ls") then
        setup_lsp("tsserver")
      end
      setup_lsp("html")
      setup_lsp("cssls")
      setup_lsp("bashls", {
        filetypes = { "sh", "bash" },
      })

      require("bufferline").setup({
        options = {
          always_show_bufferline = false,
          separator_style = "thin",
        },
      })

      local indent_highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }
      local ibl_hooks = require("ibl.hooks")
      ibl_hooks.register(ibl_hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#8F6A70" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#9A8B6C" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#6C8196" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#967B66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#738C75" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#7D6F8A" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#668B8B" })
      end)
      require("ibl").setup({
        indent = { highlight = indent_highlight },
      })
      require("nvim-tree").setup({})
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>s", "<cmd>set spell!<CR>", { noremap = true, silent = true })
    '';
  };

  ### tmux ####################################################################

  programs.tmux = {
    enable = true;
    mouse = true;
    secureSocket = true;
    terminal = "tmux-256color";
    clock24 = true;
    extraConfig = ''
      # don't rename windows automatically
      set-option -g allow-rename off

      # reload config file (change file location to your the tmux.conf you want to use)
      bind r source-file ~/.config/tmux/tmux.conf
    '';
  };

  ### ghostty #################################################################

  programs.ghostty = {
    enable = true;
    # On Darwin Ghostty is installed via Homebrew; elsewhere use Nixpkgs.
    package =
      if pkgs.stdenv.isDarwin
      then null
      else pkgs.ghostty;
    settings = {
      "macos-option-as-alt" = true;
    };
  };

  ### cursor ##################################################################

  home.file = {
    # settings
    "${cursorSettingsPath}".source = "${inputs.self}/configs/home/cursor/settings.json";
    # rules
    ".cursor/rules/commit-messages.mdc".source = "${inputs.self}/configs/home/cursor/rules/commit-messages.mdc";
    ".cursor/rules/english-code-comments.mdc".source = "${inputs.self}/configs/home/cursor/rules/english-code-comments.mdc";
    ".cursor/rules/golang-rules.mdc".source = "${inputs.self}/configs/home/cursor/rules/golang-rules.mdc";
  };
}
