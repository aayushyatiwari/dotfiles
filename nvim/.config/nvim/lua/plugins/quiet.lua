-- Quiet editor: no ghost text, no inline type hints, no type-checker nagging.
return {
  -- Belt and braces: Copilot extra is removed from lazyvim.json; make sure it
  -- never loads even if something pulls it in.
  { "zbirenbaum/copilot.lua", enabled = false },

  -- No auto-closing brackets/quotes while typing.
  { "nvim-mini/mini.pairs", enabled = false },

  -- Completion menu still works on demand, but never draws ghost text inline.
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        ghost_text = { enabled = false },
        accept = { auto_brackets = { enabled = false } },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      -- No inline `: int` / `-> str` type annotations drawn next to code.
      inlay_hints = { enabled = false },
      -- No "fix this" lightbulb / code-lens noise.
      codelens = { enabled = false },
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = { typeCheckingMode = "off" },
            },
          },
        },
      },
    },
  },
}
