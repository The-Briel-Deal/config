vim.lsp.start({
	name = 'clangd',
	cmd = { 'clangd' },
	root_dir = vim.fs.dirname(vim.fs.find({ "Makefile", "compile_commands.json", ".gitignore" }, { upward = true })[1]),
	settings = {
	}
})

local function switch_source_header()
	local method_name = 'textDocument/switchSourceHeader'
	local bufnr = 0
	local client = vim.lsp.get_clients({ bufnr = bufnr, name = 'clangd' })[1]
	if not client then
		return vim.notify(('method %s is not supported by any servers active on the current buffer'):format(method_name))
	end
	local params = vim.lsp.util.make_text_document_params(bufnr)
	client:request(method_name, params, function(err, result)
		if err then
			error(tostring(err))
		end
		if not result then
			vim.notify('corresponding file cannot be determined')
			return
		end
		vim.cmd.edit(vim.uri_to_fname(result))
	end, bufnr)
end


vim.api.nvim_buf_create_user_command(0, 'SwitchSourceHeader', switch_source_header, {})
vim.keymap.set('n', '<leader>gh', switch_source_header, { buffer = true })

require("gdb").setup {}
