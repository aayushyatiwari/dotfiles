return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- LazyVim has no `lang.sh` extra, so wire up bash-language-server ourselves.
      servers = {
        bashls = {},
      },
      -- Belt and braces on top of `vim.diagnostic.enable(false)`: even if
      -- something flips diagnostics back on, draw nothing.
      diagnostics = {
        virtual_text = false,
        virtual_lines = false,
        signs = false,
        underline = false,
        update_in_insert = false,
      },
    },
  },

  -- No external linters on top of the LSP servers.
  { "mfussenegger/nvim-lint", enabled = false },
}
