-- =============================================================================
--  init.lua — this is the entire editor. There is no other file.
--
--  Contents:
--    1. Leader          6. Completion
--    2. Options         7. Format on save
--    3. Plugins         8. Keymaps
--    4. Colorscheme     9. Terminal
--    5. LSP            10. Small comforts
--
--  Plugins: 4, managed by Neovim's built-in vim.pack (no plugin manager).
--    :lua vim.pack.update()                  update everything
--    :lua =vim.pack.get()                    list what's installed
--    :lua vim.pack.del({"name.nvim"})        uninstall (removing the line above
--                                            is not enough — it stays on disk)
--  Plugins live in ~/.local/share/nvim/site/pack/core/opt/
--  Delete that directory and everything below still works, minus colors.
-- =============================================================================

-- 1. LEADER -------------------------------------------------------------------
-- Must be set before anything binds a <leader> key.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- 2. OPTIONS ------------------------------------------------------------------
local o = vim.opt

o.number = true -- absolute number on the cursor line
o.relativenumber = true -- relative everywhere else
o.cursorline = false
o.signcolumn = "yes:1" -- always on, so text never shifts sideways
o.colorcolumn = "80"
o.wrap = false
o.scrolloff = 8 -- keep 8 lines of context above/below cursor
o.showmode = false -- the statusline already says INSERT

o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true

o.ignorecase = true -- /foo matches Foo ...
o.smartcase = true -- ... but /Foo only matches Foo
o.hlsearch = true
o.incsearch = true

o.splitright = true -- vertical splits open to the right
o.splitbelow = true -- horizontal splits open below

o.clipboard = "unnamedplus" -- y and p use the system clipboard
o.swapfile = false
o.backup = false
o.undofile = true -- undo survives closing the file
o.termguicolors = true
o.confirm = true -- :q on unsaved buffer asks instead of failing
o.updatetime = 250

-- Statusline: file, modified flag, then ruler on the right. That's all.
o.laststatus = 3 -- one statusline for the whole window, not per-split
o.statusline = "  %f %m%r%=%y  %l:%c  %P  "

-- 3. PLUGINS ------------------------------------------------------------------
-- If any of this fails, the editor still opens. That is the point of pcall.
pcall(vim.pack.add, {
	{ src = "https://github.com/Mofiqul/adwaita.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/stevearc/conform.nvim" },
})

-- 4. COLORSCHEME --------------------------------------------------------------
-- Adwaita (GNOME's palette), darkest variant.
pcall(function()
	vim.o.background = "dark"
	vim.g.adwaita_darker = true -- the darker of the two dark backgrounds
	vim.g.adwaita_disable_cursorline = true
	vim.g.adwaita_transparent = false
	vim.cmd.colorscheme("adwaita")
end)

-- Treesitter highlighting. Parsers install on first use, in the background.
-- If treesitter ever breaks after an update, delete this block: Neovim falls
-- back to its own regex syntax highlighting and nothing else is affected.
pcall(function()
	local ts = require("nvim-treesitter")
	local want = { "python", "go", "gomod", "javascript", "typescript", "tsx", "html", "css", "json", "lua", "bash" }
	local have = ts.get_installed()
	local missing = vim.tbl_filter(function(p)
		return not vim.tbl_contains(have, p)
	end, want)
	if #missing > 0 then
		ts.install(missing)
	end

	vim.api.nvim_create_autocmd("FileType", {
		desc = "Start treesitter highlighting when a parser exists",
		callback = function(ev)
			local lang = vim.treesitter.language.get_lang(ev.match)
			if lang and pcall(vim.treesitter.start, ev.buf, lang) then
				vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end,
	})
end)

-- 5. LSP ----------------------------------------------------------------------
-- Neovim 0.12 has LSP built in. No lspconfig, no mason. Each server is 4 lines.
-- A server is only enabled if its binary is actually on your PATH, so an
-- uninstalled language server is silently skipped instead of erroring at you.

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".stylua.toml", ".git" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
})

vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.work", "go.mod", ".git" },
})

vim.lsp.config("basedpyright", {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
	settings = { basedpyright = { analysis = { typeCheckingMode = "standard" } } },
})

vim.lsp.config("ruff", {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".git" },
})

vim.lsp.config("ts_ls", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { "tsconfig.json", "package.json", ".git" },
	-- ts_ls needs a copy of TypeScript to drive. It finds the project's own
	-- node_modules automatically (correct: respects a pinned version). Only when
	-- there isn't one — a loose .ts file — do we point it at a private TS 5.
	-- Without this it exits with "Could not find a valid TypeScript installation"
	-- and you get no LSP with no visible reason why.
	before_init = function(params, config)
		-- config.root_dir, not params.rootPath: the latter is deprecated and
		-- arrives as vim.NIL, which is truthy, so `or` fallbacks silently fail.
		local root = type(config.root_dir) == "string" and config.root_dir or vim.uv.cwd()
		if vim.fn.isdirectory(root .. "/node_modules/typescript") == 0 then
			params.initializationOptions = vim.tbl_deep_extend("force", params.initializationOptions or {}, {
				tsserver = { path = vim.fn.expand("~/.local/share/nvim-tsserver/node_modules/typescript/lib/tsserver.js") },
			})
		end
	end,
})

-- eslint. root_markers are eslint config files ONLY, deliberately: this way the
-- server starts in projects that actually use eslint and stays out of the ones
-- that don't, instead of attaching everywhere and complaining.
vim.lsp.config("eslint", {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
	-- root_dir is a function, not a root_markers list, and that matters: if
	-- markers find nothing Neovim still starts the server rootless, and eslint
	-- then errors on every keystroke. Never calling on_dir means never starting.
	root_dir = function(bufnr, on_dir)
		local found = vim.fs.find({
			"eslint.config.js", "eslint.config.mjs", "eslint.config.cjs", "eslint.config.ts",
			".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml",
		}, { path = vim.api.nvim_buf_get_name(bufnr), upward = true })[1]
		if found then
			on_dir(vim.fs.dirname(found))
		end
	end,
	settings = {
		validate = "on",
		useESLintClass = false,
		run = "onType",
		problems = { shortenToSingleLine = false },
		-- These four look like boilerplate but are not optional: the eslint server
		-- does path.resolve() on nodePath and reads the others unguarded, so
		-- leaving them unset makes every diagnostics request fail with
		-- 'The "path" argument must be of type string. Received undefined'.
		-- Where to find the eslint *library* (not the binary). A project's own
		-- node_modules still wins; this is only the fallback, without which a
		-- project lacking a local eslint install lints absolutely nothing and
		-- reports no error explaining why.
		nodePath = vim.fn.expand("~/.npm-global/lib/node_modules"),
		format = false, -- prettier handles formatting; eslint only reports
		quiet = false,
		onIgnoredFiles = "off",
		rulesCustomizations = {},
		codeActionOnSave = { enable = false, mode = "all" },
		-- empty_dict, not {}: a bare Lua table encodes to a JSON array and the
		-- server reads .useFlatConfig off it. Left empty so eslint auto-detects
		-- flat vs legacy config rather than us forcing the wrong one.
		experimental = vim.empty_dict(),
		codeAction = {
			disableRuleComment = { enable = true, location = "separateLine" },
			showDocumentation = { enable = true },
		},
		workingDirectory = { mode = "auto" },
	},
	before_init = function(_, config)
		local root = config.root_dir
		if type(root) == "string" then
			config.settings.workspaceFolder = { uri = root, name = vim.fn.fnamemodify(root, ":t") }
		end
	end,
})

-- Enable only what is installed.
for name, bin in pairs({
	lua_ls = "lua-language-server",
	gopls = "gopls",
	basedpyright = "basedpyright-langserver",
	ruff = "ruff",
	ts_ls = "typescript-language-server",
	eslint = "vscode-eslint-language-server",
}) do
	if vim.fn.executable(bin) == 1 then
		vim.lsp.enable(name)
	end
end

-- Diagnostics: quiet. Virtual text off, signs in the gutter, full text on hover.
vim.diagnostic.config({
	virtual_text = false,
	underline = true,
	severity_sort = true,
	float = { border = "rounded", source = true },
	signs = { text = { [vim.diagnostic.severity.ERROR] = "E", [vim.diagnostic.severity.WARN] = "W", [vim.diagnostic.severity.INFO] = "I", [vim.diagnostic.severity.HINT] = "H" } },
})

-- 6. COMPLETION ---------------------------------------------------------------
-- Built-in LSP completion. No cmp, no blink, no snippet engine.
vim.o.completeopt = "menu,menuone,noselect,popup,fuzzy"
vim.o.pumheight = 10

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Per-buffer LSP setup",
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end

		local function map(keys, fn, desc)
			vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = desc })
		end
		map("gd", vim.lsp.buf.definition, "Go to definition")
		map("gr", vim.lsp.buf.references, "References")
		map("gi", vim.lsp.buf.implementation, "Implementation")
		map("K", vim.lsp.buf.hover, "Hover docs")
		map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
		map("<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
	end,
})

-- <Tab> cycles the completion menu; otherwise it is still a Tab.
vim.keymap.set("i", "<Tab>", function()
	return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true })
vim.keymap.set("i", "<S-Tab>", function()
	return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true })

-- 7. FORMAT ON SAVE -----------------------------------------------------------
-- conform picks the right formatter per filetype and falls back to the language
-- server when no formatter is listed. Toggle off for a session with :Fmt
-- (useful in someone else's repo where reformatting would blow up the diff).
vim.g.format_on_save = true
vim.api.nvim_create_user_command("Fmt", function()
	vim.g.format_on_save = not vim.g.format_on_save
	vim.notify("format on save: " .. tostring(vim.g.format_on_save))
end, { desc = "Toggle format on save" })

pcall(function()
	require("conform").setup({
		formatters_by_ft = {
			python = { "ruff_organize_imports", "ruff_format" },
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			-- go has no entry on purpose: gopls already formats with gofmt on save.
			-- lua likewise: install stylua and add it here if you want it.
		},
		default_format_opts = { lsp_format = "fallback", timeout_ms = 2000 },
		format_on_save = function()
			if vim.g.format_on_save then
				return { timeout_ms = 2000, lsp_format = "fallback" }
			end
		end,
	})
end)

-- 8. KEYMAPS ------------------------------------------------------------------
-- Deliberately the same keys LazyVim used, so your fingers do not have to relearn.
local map = vim.keymap.set

-- Escape / clipboard (kept from your old config)
map({ "i", "x" }, "<C-c>", "<Esc>", { desc = "Escape" })
map("n", "<C-c>", '"+yy', { desc = "Copy line to clipboard" })
map("x", "<C-c>", '"+y', { desc = "Copy selection to clipboard" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Every keymap in this file is browsable/searchable with <leader>?
map("n", "<leader>?", "<cmd>FzfLua keymaps<cr>", { desc = "Search all keymaps" })
map("n", "<leader>cf", function()
	require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format buffer now" })

-- Files / search — fzf-lua
-- INSIDE the picker, these decide WHERE the file opens:
--   <Enter>   current window        <C-v>  vertical split (side by side)
--   <C-t>     new tab               <C-s>  horizontal split (stacked)
map("n", "<leader><space>", "<cmd>FzfLua files<cr>", { desc = "Find files" })
map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find files" })
map("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { desc = "Grep project" })
map("n", "<leader>,", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Recent files" })
map("n", "<leader>fh", "<cmd>FzfLua helptags<cr>", { desc = "Help" })
map("n", "<leader>sd", "<cmd>FzfLua diagnostics_workspace<cr>", { desc = "Diagnostics" })
map("n", "<leader>ss", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "Symbols in file" })

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bb", "<cmd>edit #<cr>", { desc = "Last buffer" })

-- Windows
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<leader>-", "<C-w>s", { desc = "Split below" })
map("n", "<leader>|", "<C-w>v", { desc = "Split right" })
map("n", "<leader>wd", "<C-w>c", { desc = "Close window" })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Taller" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Shorter" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Narrower" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Wider" })

-- Tabs
map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous tab" })

-- Files
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "File explorer (netrw)" })

-- Move lines up/down, keeping indentation sane
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Keep the cursor centred when jumping around
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Stay in visual mode when indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Diagnostics
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Previous diagnostic" })

-- 9. TERMINAL -----------------------------------------------------------------
-- A horizontal split terminal at the project root, toggled with the same keys
-- you already use. One terminal, reused — not a new one every time.
local term = { buf = nil, win = nil }

local function toggle_term()
	if term.win and vim.api.nvim_win_is_valid(term.win) then
		vim.api.nvim_win_hide(term.win)
		term.win = nil
		return
	end
	vim.cmd("botright " .. math.floor(vim.o.lines * 0.3) .. "split")
	term.win = vim.api.nvim_get_current_win()
	if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
		vim.api.nvim_win_set_buf(term.win, term.buf)
	else
		vim.cmd.terminal()
		term.buf = vim.api.nvim_get_current_buf()
		vim.bo[term.buf].buflisted = false
	end
	vim.cmd.startinsert()
end

map({ "n", "t" }, "<C-t>", toggle_term, { desc = "Toggle terminal" })
map({ "n", "t" }, "<leader>t", toggle_term, { desc = "Toggle terminal", nowait = true })
map("t", "<C-\\>", "<C-\\><C-n>", { desc = "Leave terminal insert mode" })

vim.api.nvim_create_autocmd("TermOpen", {
	desc = "Terminals do not need line numbers",
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
	end,
})

-- 10. SMALL COMFORTS ----------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Briefly highlight what you just yanked",
	callback = function()
		vim.hl.on_yank({ timeout = 150 })
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Create missing parent directories on save",
	callback = function(ev)
		if not ev.match:match("^%w+://") then
			vim.fn.mkdir(vim.fn.fnamemodify(vim.uv.fs_realpath(ev.match) or ev.match, ":p:h"), "p")
		end
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Reopen a file on the line you left it",
	callback = function(ev)
		local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
		if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- netrw: make the built-in file explorer usable so no file-tree plugin is needed
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
