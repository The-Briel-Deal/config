-- vim.opt_global.python_recommended_style = 0
vim.opt_local.shiftwidth = 2

local root_files = {
	'.git',
}

vim.lsp.start({
	name = 'glsl_analyzer',
	cmd = { 'glsl_analyzer' },
	root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
	capabilities = {},
})
