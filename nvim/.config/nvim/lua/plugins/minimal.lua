local function add(list, items)
  for _, item in ipairs(items) do
    if not vim.tbl_contains(list, item) then
      table.insert(list, item)
    end
  end
end

return {
  -- Vim-style editing helpers.
  {
    "easymotion/vim-easymotion",
    keys = {
      { "<leader><leader>", "<Plug>(easymotion-prefix)", mode = { "n", "x", "o" }, desc = "EasyMotion" },
    },
    init = function()
      vim.g.EasyMotion_smartcase = 1
    end,
  },
  { "tpope/vim-surround", event = "VeryLazy" },

  -- Keep LazyVim quiet and predictable.
  { "saghen/blink.cmp", enabled = false },
  { "rafamadriz/friendly-snippets", enabled = false },
  { "folke/flash.nvim", enabled = false },
  { "folke/noice.nvim", enabled = false },
  { "folke/persistence.nvim", enabled = false },
  { "folke/todo-comments.nvim", enabled = false },
  { "folke/trouble.nvim", enabled = false },
  { "akinsho/bufferline.nvim", enabled = false },

  -- Language basics for Python, C/C++, Java, and Go.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
        clangd = {},
        jdtls = {},
        gopls = {},
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      add(opts.ensure_installed, { "pyright", "clangd", "jdtls", "gopls" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      add(opts.ensure_installed, {
        "python",
        "c",
        "cpp",
        "java",
        "go",
        "gomod",
        "gosum",
        "gowork",
      })
    end,
  },
}
