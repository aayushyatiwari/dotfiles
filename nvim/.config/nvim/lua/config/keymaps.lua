-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Toggle Copilot's inline ghost-text suggestions (<leader>uk)
Snacks.toggle({
  name = "Copilot Suggestions",
  get = function()
    return not require("copilot.client").is_disabled()
  end,
  set = function(state)
    require("copilot.command")[state and "enable" or "disable"]()
  end,
}):map("<leader>uk")
