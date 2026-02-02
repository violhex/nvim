vim.g.mapleader = " "

vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 8
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"

vim.opt.background = "dark"
vim.opt.clipboard = "unnamedplus"

local function pack_clean()
	local activePlugins = {}
	local unusedPlugins = {}

	for _, plugin in ipairs(vim.pack.get()) do
		activePlugins[plugin.spec.name] = plugin.active
	end

	for _, plugin in ipairs(vim.pack.get()) do
		if not activePlugins[plugin.spec.name] then
			table.insert(unusedPlugins, plugin.spec.name)
		end
	end

	if #unusedPlugins == 0 then
		print("[INFO] Unused Plugins: 0")
		return
	end

	local choice = vim.fn.confirm("[PROMPT] Remove unused plugins?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(unusedPlugins)
	else
		print("[INFO] Skipping plugin removal")
	end
end

vim.pack.add({
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
	{ src = "https://github.com/mrcjkb/rustaceanvim" },
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/folke/lazydev.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/L3MON4D3/luasnip" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
	{ src = "https://github.com/ramojus/mellifluous.nvim" },
	{ src = "https://github.com/Mofiqul/vscode.nvim" }
})

require("conform").setup({
	formatters = {
		uv_ruff = {
			command = "uv",
			args = { "run", "ruff", "format", "--stdin-filename", "$FILENAME", "-" },
			stdin = true
		},
		bun_prettier = {
			command = "bunx",
			args = { "prettier", "--write", "$FILENAME" },
			stdin = false
		}
	},
	formatters_by_ft = {
		python = { "uv_ruff", "ruff_format", "lsp" },
		javascript = { "bun_prettier" },
		javascriptreact = { "bun_prettier" },
		typescript = { "bun_prettier" },
		typescriptreact = { "bun_prettier" },
		json = { "bun_prettier" },
		css = { "bun_prettier" },
		html = { "bun_prettier" },
		markdown = { "bun_prettier" },
		["markdown.mdx"] = { "bun_prettier" },
		go = { "gofumpt", "gofmt" },
		lua = { "stylua" },
		c = { "clang_format" },
		cpp = { "clang_format" },
		typst = { "tinymist" },
		["_"] = { "lsp" }
	}
})

require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "-" },
		changedelete = { text = "~-" },
	},
})

require("toggleterm").setup({
	open_mapping = [[<c-\>]],
	direction = "float",
})

require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})

local ls = require("luasnip")
ls.config.set_config({
	history = true,
	updateevents = "TextChangedI",
	enable_autosnippets = true,
})
require("luasnip.loaders.from_lua").load({
	paths = vim.fn.stdpath("config") .. "/snippets"
})


require("blink.cmp").setup({
	keymap = { preset = "super-tab" },
	completion = { documentation = { auto_show = true } },
	fuzzy = { implementation = "prefer_rust_with_warning" },
	snippets = { preset = "luasnip" },
	sources = {
		default = { "lazydev", "lsp", "path", "snippets", "buffer" },
		per_filetype = {
			lua = { inherit_defaults = true, "lazydev" },
		},
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				score_offset = 100,
			},
		},
	},
})

require("oil").setup({
	columns = { "permissions", "icon" },
	view_options = { show_hidden = true },
})

require("kanagawa").setup({
	overrides = function(colors)
		local bg = colors.theme.ui.bg
		return {
			LineNr = { bg = bg },
			CursorLineNr = { bg = bg },
			SignColumn = { bg = bg },
			FoldColumn = { bg = bg },
			LineNrAbove = { bg = bg },
			LineNrBelow = { bg = bg },
		}
	end,
	theme = "dragon",
	background = {
		dark = "dragon",
		light = "lotus",
	},
})
-- vim.cmd.colorscheme("kanagawa")

require("gruvbox").setup({
	contrast = "medium",
	italic = {
		strings = false,
		comments = true,
		operators = false,
		folds = true
	},
	transparent_mode = false
})
-- vim.cmd.colorscheme("gruvbox")

require("mellifluous").setup({})
-- vim.cmd.colorscheme("mellifluous")

require("vscode").setup({
    transparent = false,
    italic_comments = true,
    italic_inlayhints = true,
    underline_links = true,
    terminal_colors = true,
})
vim.cmd.colorscheme("vscode")

require("typst-preview").setup()

require("trouble").setup()

require("mini.basics").setup()
require("mini.pick").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.statusline").setup()

vim.keymap.set("n", "<leader>pc", pack_clean)
vim.keymap.set("n", "<leader>f", ":Oil<CR>")
vim.keymap.set("n", "<leader>ff", ":Pick files<CR>")
vim.keymap.set("n", "<leader>h", ":Pick help<CR>")
vim.keymap.set("n", "<leader>g", ":Pick grep_live<CR>")
vim.keymap.set("n", "<leader>b", ":Pick buffers<CR>")
vim.keymap.set({ "n", "v" }, "<C-c>", '"+y', { silent = true })
vim.keymap.set("n", "<C-c><C-c>", '"+yy', { silent = true })
vim.keymap.set("n", "<leader>q", ":Trouble diagnostics toggle<CR>")
vim.keymap.set("n", "<leader>ih", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end)
vim.keymap.set("n", "<leader>tp", "<cmd>TypstPreview<CR>")
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>lf", function()
	require("conform").format({
		timeout_ms = 2000,
		lsp_fallback = true,
	})
end)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

vim.filetype.add({
	extension = {
		mdx = "markdown.mdx",
		typ = "typst",
		gotmpl = "gotmpl",
	},
	filename = {
		["go.work"] = "gowork",
		["go.work.sum"] = "gowork",
	},
	pattern = {
		[".*%.tmpl"] = "gotmpl",
		[".*%.tpl"] = "gotmpl",
	},
})

require("lspconfig")

local capabilities = require("blink.cmp").get_lsp_capabilities()

local function setup(name, cfg)
	cfg = cfg or {}
	cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
	vim.lsp.config(name, cfg)
end

setup("html", {})
setup("cssls", {})
setup("marksman", {})
setup("clangd", {})

setup("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
})

setup("ts_ls", {
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
})

setup("emmet_language_server", {
	filetypes = { "html", "css", "scss", "less", "javascriptreact", "typescriptreact" },
})

setup("pyright", {
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "basic",
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
			},
		},
	},
})

setup("gopls", {
	settings = {
		gopls = {
			gofumpt = true,
			analyses = { unusedparams = true },
			staticcheck = true,
		},
	},
})

setup("tinymist", {
	cmd = { "tinymist" },
	filetypes = { "typst" },
	settings = {
		formatterMode = "typstyle",
		exportPdf = "onType",
		semanticTokens = "disable",

	},
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = true
		client.server_capabilities.documentRangeFormattingProvider = true
	end
})

local servers = {
	"lua_ls",
	"ts_ls",
	"emmet_language_server",
	"html",
	"cssls",
	"marksman",
	"pyright",
	"clangd",
	"gopls",
	"tinymist",
}

for _, server in ipairs(servers) do
	pcall(vim.lsp.enable, server)
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			vim.schedule(function()
				print("[LSP] attached:", client.name, "->", vim.api.nvim_buf_get_name(args.buf))
			end)
		end
	end,
})
