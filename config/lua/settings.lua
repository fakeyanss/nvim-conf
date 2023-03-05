local env = require("env")
local settings = {}

settings["leader_key"] = " "
settings["window_keymap_enable"] = true
settings["lsp_list"] = {
	"bashls",
	"clangd",
	"cmake",
	"dockerls",
	"gopls",
	"html",
	"jsonls",
	"lua_ls",
	"pyright",
	"rust_analyzer",
	"jdtls",
}
settings["null_ls_list"] = {
	-- formatting
	"black",
	"clang_format",
	"eslint_d",
	"jq",
	"markdownlint",
	"prettierd",
	"rustfmt",
	"shfmt",
	"stylua",
	"google-java-format",
	-- diagnostics
	"shellcheck",
	"markdownlint",
}
settings["dap_list"] = {
	"java-test",
	"delve",
	"debugpy",
	"stylua",
}
settings["formatting"] = {
	-- Set it to false if there are no need to format on save.
	format_on_save = true,
	-- Set the format disabled directories here, files under these dirs won't be formatted on save.
	format_disabled_dirs = {
		env.home .. "/format_disabled_dir_under_home",
	},
}
-- java lsp and dap is setup standalone, so set it here.
settings["java"] = {
	java_17_home = "/usr/local/lib/java/" .. "/java-17-openjdk/",
	java_11_home = "/usr/local/lib/java/" .. "/java-11-openjdk/",
	java_8_home = "/usr/local/lib/java/" .. "/java-8-openjdk/",
}
-- settings["colorscheme"] = "catppuccin"
settings["load_big_files_faster"] = true

return settings
