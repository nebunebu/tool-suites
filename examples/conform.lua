require("conform").setup({
	formatters_by_ft = {
    bash = { "shfmt" },
    json = { "fixjson" },
    html = { "htmlbeautifier" },
		lua = { "stylua" },
		markdown = { "markdownlint" },
		nix = { "nixfmt" },
		scss = { "prettierd" },
		tex = { "latexindent" },
		xml = { "xmlformat" },
		yaml = { "yamlfmt" },
    ["*"] = { "trim_whitespace", "trim_newlines" },
	},

	format_on_save = { lsp_format = "fallback" },
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
