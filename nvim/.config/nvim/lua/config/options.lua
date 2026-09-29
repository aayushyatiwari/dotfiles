-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.snacks_animate = true

-- Use basedpyright as the Python LSP (installed via Mason; superset of pyright)
vim.g.lazyvim_python_lsp = "basedpyright"

-- Don't reformat / reorder imports on save
vim.g.autoformat = false

-- No ghost text from the completion menu (i.e. from the LSPs).
-- Copilot goes back to drawing its own inline suggestions instead of
-- riding in blink.cmp, so <leader>uk still toggles them.
vim.g.ai_cmp = false

-- No diagnostics anywhere: no virtual text, no signs, no underlines, no
-- statusline counts. LSP servers still run, so go-to-definition, hover and
-- references keep working -- they just stop complaining.
vim.diagnostic.enable(false)
