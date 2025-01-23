print("Starting Lua LSP!")
vim.lsp.start({
  name = 'luals',
  cmd = {'lua-language-server'},
  root_dir = vim.fs.dirname(vim.fs.find({"init.lua", ".gitignore"}, { upward = true })[1]),
  settings = {
		Lua = { 
			workspace = { 
				library = { vim.env.VIMRUNTIME } 
			} 
		} 
	} 
})
