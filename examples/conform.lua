require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "nixfmt" },
		sh = { "shellfmt" },
		tex = { "latexindent" },
		xml = { "xmlformat" },
		yaml = { "yamlfmt" },
	},
})
