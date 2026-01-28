vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 8
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"

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
})

require("gitsigns").setup({
    signs = {
	add = {text="+"},
	change={text="~"},
	delete={text="_"},
	topdelete={text="-"},
	changedelete={text="~-"},
    }
})

require("toggleterm").setup({
	open_mapping = [[<c-\>]],
	direction = "float"
})

require("blink.cmp").setup({
	keymap = { preset = "super-tab" },
	completion = { documentation = { auto_show = true } },
	fuzzy = { implementation = "prefer_rust_with_warning" }
})

require("oil").setup({
	columns = {
		"permissions",
		"icon",
	},
	view_options = {
		show_hidden = true
	}
})

require("trouble").setup()
require("mini.basics").setup()
require("mini.pick").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.statusline").setup()

require("kanagawa").setup({
	overrides = function(colors)
		local bg = colors.theme.ui.bg
		return {
			-- Numbers Gutter
			LineNr       = { bg = bg },
			CursorLineNr = { bg = bg },

			-- Sign/Fold Columns
			SignColumn   = { bg = bg },
			FoldColumn   = { bg = bg },

			-- Extra
			LineNrAbove  = { bg = bg },
			LineNrBelow  = { bg = bg }
		}
	end,
	theme = "dragon",
	background = {
		dark = "dragon",
		light = "lotus"
	},
})

vim.cmd.colorscheme("kanagawa")

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pc", pack_clean)
vim.keymap.set("n", "<leader>f", ":Oil<CR>")
vim.keymap.set("n", "<leader>ff", ":Pick files<CR>")
vim.keymap.set("n", "<leader>h", ":Pick help<CR>")
vim.keymap.set("n", "<leader>g", ":Pick grep_live<CR>")
vim.keymap.set("n", "<leader>b", ":Pick buffers<CR>")
vim.keymap.set({ "n", "v" }, "<C-c>", '"+y', { silent = true })
vim.keymap.set("n", "<C-c><C-c>", '"+yy', { silent = true })
vim.keymap.set("n", "<leader>q", ":Trouble diagnostics toggle<CR>")
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true
})


local capabilities = require("blink.cmp").get_lsp_capabilities()

local function setup(name, cfg)
	cfg = cfg or {}
	cfg.capabilities = cfg.capabilities or capabilities
	vim.lsp.config(name, cfg)
end

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
	"tinymist"
}

for _, server in ipairs(servers) do
	vim.lsp.enable(server)
end

setup("ts_ls", {
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
})

setup("emmet_language_server", {
	filetypes = {
		"html",
		"css",
		"scss",
		"less",
		"javascriptreact",
		"typescriptreact",
	},
})

setup("html", {})
setup("cssls", {})
setup("marksman", {})
setup("lua_ls", {})

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

setup("clangd", {})

setup("gopls", {
	settings = {
		gopls = {
			gofumpt = true,
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
})

setup("tinymist", {
	filetypes = { "typst" }
})
