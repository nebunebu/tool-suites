require("lint").linters_by_ft = {
	bash = { "shellcheck" },
	lua = { "luacheck" },
	nix = { "deadnix", "statix" },
	tex = { "chktex" },
	xml = { "xmllint" },
	yaml = { "yamllint" },
}
