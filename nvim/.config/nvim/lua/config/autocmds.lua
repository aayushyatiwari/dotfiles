-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Remember the mode a terminal was left in, and restore it on the way back.
-- Without this you always land in terminal (insert) mode, losing a normal-mode
-- scrollback position every time you hop to a file and back.
local term_mode = vim.api.nvim_create_augroup("term_mode_memory", { clear = true })

vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
  group = term_mode,
  pattern = "term://*",
  callback = function(ev)
    if vim.api.nvim_get_current_buf() == ev.buf then
      -- "t" = terminal-insert, "n"/"nt" = normal mode inside the terminal
      vim.b[ev.buf].last_term_mode = vim.fn.mode()
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = term_mode,
  pattern = "term://*",
  callback = function(ev)
    if vim.api.nvim_get_current_buf() ~= ev.buf then
      return
    end
    if vim.b[ev.buf].last_term_mode == "t" then
      vim.cmd.startinsert()
    end
  end,
})
