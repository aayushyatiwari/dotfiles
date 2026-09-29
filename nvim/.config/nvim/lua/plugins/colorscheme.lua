-- Adwaita (darker) pushed all the way to OLED black, with a transparent bg.
--
-- `adwaita_darker` gets the palette to GNOME's darkest greys; the ColorScheme
-- hook below then clears every "background" surface so your terminal's own
-- (black) background shows through. Flip TRANSPARENT to false to get opaque
-- #000000 instead -- everything else stays the same.

local TRANSPARENT = true
local BLACK = "#000000"
local BG = TRANSPARENT and "NONE" or BLACK

-- Surfaces that should be transparent / true black.
local bg_groups = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "FloatBorder",
  "FloatTitle",
  "SignColumn",
  "FoldColumn",
  "LineNr",
  "LineNrAbove",
  "LineNrBelow",
  "EndOfBuffer",
  "MsgArea",
  "MsgSeparator",
  "StatusLine",
  "StatusLineNC",
  "WinBar",
  "WinBarNC",
  "TabLine",
  "TabLineFill",
  "TabLineSel",
  "Folded",
  "NonText",
  "Pmenu",
  -- plugin surfaces LazyVim shows constantly
  "NeoTreeNormal",
  "NeoTreeNormalNC",
  "NeoTreeEndOfBuffer",
  "NeoTreeWinSeparator",
  "SnacksNormal",
  "SnacksNormalNC",
  "SnacksWinBar",
  "SnacksBackdrop",
  "SnacksPickerNormal",
  "SnacksPickerPreview",
  "SnacksPickerList",
  "SnacksPickerInput",
  "SnacksPickerBorder",
  "SnacksDashboardNormal",
  "SnacksDashboardDesc",
  "SnacksDashboardIcon",
  "SnacksNotifierInfo",
  "BlinkCmpMenu",
  "BlinkCmpMenuBorder",
  "BlinkCmpDoc",
  "BlinkCmpDocBorder",
  "BlinkCmpSignatureHelp",
  "NoiceCmdlinePopup",
  "NoiceCmdlinePopupBorder",
  "NoicePopup",
  "NoiceMini",
  "WhichKeyNormal",
  "WhichKeyBorder",
  "TelescopeNormal",
  "TelescopeBorder",
  "LazyNormal",
  "MasonNormal",
  "TroubleNormal",
  "TroubleNormalNC",
  "DiagnosticVirtualTextError",
  "DiagnosticVirtualTextWarn",
  "DiagnosticVirtualTextInfo",
  "DiagnosticVirtualTextHint",
}

-- These must stay visible, so they keep a faint lift instead of going clear.
local tint_groups = {
  CursorLine = "#101010",
  CursorLineNr = "#101010",
  ColorColumn = "#101010",
  Visual = "#25323b",
  PmenuSel = "#25323b",
  PmenuSbar = "#101010",
  PmenuThumb = "#2f2f2f",
  BlinkCmpMenuSelection = "#25323b",
  SnacksPickerListCursorLine = "#25323b",
}

local function set_bg(group, bg)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if not ok or not hl then
    return
  end
  hl = vim.tbl_extend("force", hl, { bg = bg })
  pcall(vim.api.nvim_set_hl, 0, group, hl)
end

local function oledify()
  for _, group in ipairs(bg_groups) do
    set_bg(group, BG)
  end
  for group, bg in pairs(tint_groups) do
    set_bg(group, bg)
  end
  -- window separators: visible line, no glowing background block
  pcall(vim.api.nvim_set_hl, 0, "WinSeparator", { fg = "#2a2a2a", bg = BG })
  pcall(vim.api.nvim_set_hl, 0, "VertSplit", { fg = "#2a2a2a", bg = BG })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("oled_black", { clear = true }),
  pattern = "*",
  callback = oledify,
})

return {
  {
    "Mofiqul/adwaita.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.adwaita_darker = true -- darkest Adwaita variant
      vim.g.adwaita_transparent = TRANSPARENT
      vim.g.adwaita_disable_cursorline = false
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "adwaita" },
  },
}
