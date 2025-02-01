vim.lsp.start({
	name = 'clangd',
	cmd = { 'clangd' },
	root_dir = vim.fs.dirname(vim.fs.find({ "Makefile", "compile_commands.json", ".gitignore" }, { upward = true })[1]),
	settings = {
	}
})

require("gdb").setup {}
