local myAutoGroup = vim.api.nvim_create_augroup("myAutoGroup", {
	clear = true,
})

local autocmd = vim.api.nvim_create_autocmd

-- 自动切换输入法，需要安装 im-select
-- https://github.com/daipeihust/im-select
autocmd("InsertLeave", {
	group = myAutoGroup,
	callback = require("modules.utils.im-select").macInsertLeave,
})
autocmd("InsertEnter", {
	group = myAutoGroup,
	callback = require("modules.utils.im-select").macInsertEnter,
})
