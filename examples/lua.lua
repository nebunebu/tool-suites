require("lspconfig").lua_ls.setup({})

require("lint").linters_by_ft = {
	lua = { "luacheck" },
}

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
	},
})
