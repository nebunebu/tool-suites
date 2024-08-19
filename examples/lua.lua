require("lspconfig").nixd.setup({})

require("lint").linters_by_ft = {
	nix = { "deadnix", "statix" },
}

require("conform").setup({
	formatters_by_ft = {
		nix = { "nixfmt" },
	},
})
