local root_files = {
	'.luarc.json',
	'.luarc.jsonc',
	'.luacheckrc',
	'.stylua.toml',
	'stylua.toml',
	'selene.toml',
	'selene.yml',
	'init.lua',
}
local root = vim.fs.find(root_files, { stop = vim.env.HOME })
local root_dir = vim.fs.dirname(root[1])

if root_dir then
	vim.lsp.start({
		cmd = { 'lua-language-server' },
		root_dir = root_dir,
		settings = {
			Lua = {
				diagnostics = { globals = { 'vim' } },
				workspace = {
					library = {
						[vim.fn.expand('$VIMRUNTIME/lua')] = true,
					}
				}
			}
		}
	})
end
