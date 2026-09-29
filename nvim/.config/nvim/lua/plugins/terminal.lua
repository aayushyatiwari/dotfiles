-- One terminal, always rooted at the project root.
--
-- LazyVim maps <C-/> to `Snacks.terminal.focus(nil, { cwd = LazyVim.root() })`.
-- `LazyVim.root()` is resolved per *buffer*, and Snacks keys its terminals on
-- `cmd + cwd + env + v:count1` -- so a different root (or an accidental count
-- prefix) silently spawns another terminal. Hence the four terminals.
--
-- Below: a single cwd derived from Neovim's own cwd, and a pinned count.

---@return string
local function project_root()
  local cwd = vim.uv.cwd() or vim.fn.getcwd()
  local git = vim.fs.find(".git", { path = cwd, upward = true })[1]
  return git and vim.fs.dirname(git) or cwd
end

local function main_terminal()
  Snacks.terminal.focus(nil, {
    cwd = project_root(),
    count = 1, -- ignore v:count1 so `2<C-/>` can't fork a second terminal
  })
end

return {
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        -- Don't force insert mode on every BufEnter; config/autocmds.lua
        -- restores whichever mode the terminal was left in instead.
        auto_insert = false,
      },
    },
    keys = {
      { "<c-/>", main_terminal, mode = { "n", "t" }, desc = "Terminal (Root Dir)" },
      { "<c-_>", main_terminal, mode = { "n", "t" }, desc = "which_key_ignore" },
      -- <leader>ft / <leader>fT would open *other* terminals by cwd; point them
      -- at the same one so there is only ever the single root terminal.
      { "<leader>ft", main_terminal, desc = "Terminal (Root Dir)" },
      { "<leader>fT", main_terminal, desc = "Terminal (Root Dir)" },
    },
  },
}
