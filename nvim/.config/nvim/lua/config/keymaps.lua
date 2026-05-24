-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--#region
vim.keymap.set("n", "d;", "d$")
vim.keymap.set("n", "c;", "c$")
vim.keymap.set("v", "<C-c>", '"+y')
vim.keymap.set("i", "<C-v>", "<C-r>+")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
