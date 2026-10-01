{pkgs, ...}: {
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
      gitsigns-nvim
      nvim-tree-lua
      indent-blankline-nvim
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
      require("gitsigns").setup({})
      require("nvim-tree").setup({})
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>s", "<cmd>set spell!<CR>", { noremap = true, silent = true })
    '';
  };
}
