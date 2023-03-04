-- get the current OS
local env = require("env")
local os
if env.is_mac then
	os = "mac"
elseif env.is_windows or env.is_wsl then
	os = "win"
elseif env.is_linux then
	os = "linux"
else
	vim.notify("Not supported system")
end

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
local jdtls_install_dir = env.data_path .. "/mason/packages/jdtls"
local lombok_path = jdtls_install_dir .. "/lombok.jar"
local workspace_dir = env.data_path .. "/project_nvim/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
local formater_path = "~/.config/nvim/config/lua/modules/edit/lsp/serverss/java-google-formatter.xml"
local openjdk_dir = "/usr/local/lib/java"

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {}

config["flag"] = {
	allow_incremental_sync = true,
}
config["filetypes"] = { "java" }

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- capabilities.workspace.configuration = true
config["capabilities"] = capabilities

config["on_attach"] = function(client, bufnr)
	require("jdtls.setup").add_commands()
	require("jdtls").setup_dap()
	require("jdtls.dap").setup_dap_main_class_configs()
	-- require("lsp-status").register_progress()
	-- require("compe").setup({
	-- 	enabled = true,
	-- 	autocomplete = true,
	-- 	debug = false,
	-- 	min_length = 1,
	-- 	preselect = "enable",
	-- 	throttle_time = 80,
	-- 	source_timeout = 200,
	-- 	incomplete_delay = 400,
	-- 	max_abbr_width = 100,
	-- 	max_kind_width = 100,
	-- 	max_menu_width = 100,
	-- 	documentation = true,

	-- 	source = {
	-- 		path = true,
	-- 		buffer = true,
	-- 		calc = true,
	-- 		vsnip = false,
	-- 		nvim_lsp = true,
	-- 		nvim_lua = true,
	-- 		spell = true,
	-- 		tags = true,
	-- 		snippets_nvim = false,
	-- 		treesitter = true,
	-- 	},
	-- })

	require("lspkind").init()
	require("lspsaga").init_lsp_saga()

	-- Kommentary
	vim.api.nvim_set_keymap("n", "<leader>/", "<plug>kommentary_line_default", {})
	vim.api.nvim_set_keymap("v", "<leader>/", "<plug>kommentary_visual_default", {})

	-- require("formatter").setup({
	-- 	filetype = {
	-- 		java = {
	-- 			function()
	-- 				return {
	-- 					exe = "java",
	-- 					args = {
	-- 						"-jar",
	-- 						os.getenv("HOME") .. "/.local/jars/google-java-format.jar",
	-- 						vim.api.nvim_buf_get_name(0),
	-- 					},
	-- 					stdin = true,
	-- 				}
	-- 			end,
	-- 		},
	-- 	},
	-- })

	-- vim.api.nvim_exec(
	-- 	[[
	--        augroup FormatAutogroup
	--          autocmd!
	--          autocmd BufWritePost *.java FormatWrite
	--        augroup end
	--      ]],
	-- 	true
	-- )

	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	local opts = { noremap = true, silent = true }
	-- buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	-- buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	-- buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	-- buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	-- buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	-- buf_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	-- buf_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	-- buf_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	-- buf_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	-- buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	-- buf_set_keymap("n", "gr", '<cmd>lua vim.lsp.buf.references() && vim.cmd("copen")<CR>', opts)
	-- buf_set_keymap("n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
	-- buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	-- buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	-- buf_set_keymap("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
	-- Java specific
	buf_set_keymap("n", "<leader>lji", "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
	buf_set_keymap("n", "<leader>ljt", "<Cmd>lua require'jdtls'.test_class()<CR>", opts)
	buf_set_keymap("n", "<leader>ljn", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", opts)
	buf_set_keymap("v", "<leader>lje", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
	buf_set_keymap("n", "<leader>lje", "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
	buf_set_keymap("v", "<leader>ljm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)

	-- buf_set_keymap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

	vim.api.nvim_exec(
		[[
          hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
          hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
          hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
          augroup lsp_document_highlight
            autocmd!
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          augroup END
      ]],
		false
	)
end

-- The command that starts the language server
-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
config["cmd"] = {
	"/usr/local/lib/java/java-17-openjdk/bin/java", -- or '/path/to/java17_or_newer/bin/java'
	-- depends on if `java` is in your $PATH env variable and if it points to the right version.

	"-Declipse.application=org.eclipse.jdt.ls.core.id1",
	"-Dosgi.bundles.defaultStartLevel=4",
	"-Declipse.product=org.eclipse.jdt.ls.core.product",
	"-Dlog.protocol=true",
	"-Dlog.level=ALL",
	"-Dfile.encoding=utf-8",
	"-Xms1g",
	"--add-modules=ALL-SYSTEM",
	"--add-opens",
	"java.base/java.util=ALL-UNNAMED",
	"--add-opens",
	"java.base/java.lang=ALL-UNNAMED",
	"-javaagent:" .. lombok_path,
	"-jar",
	vim.fn.glob(jdtls_install_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
	-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                    ^^^^^^^^^^^^^^
	-- Must point to the                                                  Change this to
	-- eclipse.jdt.ls installation                                        the actual version

	"-configuration",
	jdtls_install_dir .. "/config_" .. os,
	-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
	-- Must point to the                      Change to one of `linux`, `win` or `mac`
	-- eclipse.jdt.ls installation            Depending on your system.

	-- See `data directory configuration` section in the README
	"-data",
	workspace_dir,
}

-- This is the default if not provided, you can remove it. Or adjust as needed.
-- One dedicated LSP server & client will be started per unique root_dir
config["root_dir"] = root_dir

-- Here you can configure eclipse.jdt.ls specific settings
-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
-- for a list of options
config["settings"] = {
	-- ["java.format.settings.url"] = home .. "/.config/nvim/language-servers/java-google-formatter.xml",
	-- ["java.format.settings.profile"] = "GoogleStyle",
	java = {
		eclipse = {
			downloadSources = true,
		},
		format = {
			comments = {
				enabled = true,
			},
			settings = {
				url = formater_path,
				profile = "GoogleStyle",
			},
		},
		maxConcurrentBuilds = 5,
		saveActions = {
			organizeImports = true,
		},
		trace = {
			server = "verbose",
		},
		referencesCodeLens = {
			enabled = true,
		},
		implementationsCodeLens = {
			enabled = true,
		},
		signatureHelp = { enabled = true },
		contentProvider = { preferred = "fernflower" },
		import = {
			maven = {
				enabled = true,
			},
			exclusions = {
				"**/node_modules/**",
				"**/.metadata/**",
				"**/archetype-resources/**",
				"**/META-INF/maven/**",
				"**/Frontend/**",
				"**/CSV_Aggregator/**",
			},
		},
		maven = {
			downloadSources = true,
		},
		autobuild = {
			enabled = true,
		},
		completion = {
			filteredTypes = { "java.awt.List", "com.sun.*" },
			overwrite = false,
			guessMethodArguments = true,
			favoriteStaticMembers = {
				"org.hamcrest.MatcherAssert.assertThat",
				"org.hamcrest.Matchers.*",
				"org.hamcrest.CoreMatchers.*",
				"org.junit.jupiter.api.Assertions.*",
				"java.util.Objects.requireNonNull",
				"java.util.Objects.requireNonNullElse",
				"org.mockito.Mockito.*",
			},
		},
		sources = {
			organizeImports = {
				starThreshold = 9999,
				staticStarThreshold = 9999,
			},
		},
		codeGeneration = {
			toString = {
				template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
			},
		},
		decompiler = {
			fernflower = {
				asc = 1,
				ind = "    ",
			},
		},
		configuration = {
			runtimes = {
				{
					name = "JavaSE-17",
					path = openjdk_dir .. "/java-17-openjdk/",
				},
				{
					name = "JavaSE-11",
					path = openjdk_dir .. "/java-11-openjdk/",
				},
				{
					name = "JavaSE-1.8",
					path = openjdk_dir .. "/java-8-openjdk/",
					default = true,
				},
			},
		},
	},
}

config["on_init"] = function(client, _)
	client.notify("workspace/didChangeConfiguration", { settings = config.settings })
end

local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
-- Language server `initializationOptions`
-- You need to extend the `bundles` with paths to jar files
-- if you want to use additional eclipse.jdt.ls plugins.
--
-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
--
-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
config["init_options"] = {
	-- bundles = bundles;
	extendedClientCapabilities = extendedClientCapabilities,
}

return config

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
-- require("jdtls").start_or_attach(config)
