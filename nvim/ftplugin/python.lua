vim.g.python_recommended_style = 0
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

vim.keymap.set('v', '<leader>fm', '!pyink -q --line-length=80 --unstable --pyink-indentation=2 --pyink-use-majority-quotes - <Enter>', {buffer=true})

local root_files = {
	'pyproject.toml',
	'setup.py',
	'setup.cfg',
	'requirements.txt',
	'Pipfile',
	'pyrightconfig.json',
	'.git',
}

--local function organize_imports()
--	local params = {
--		command = 'pyright.organizeimports',
--		arguments = { vim.uri_from_bufnr(0) },
--	}
--
--	local clients = util.get_lsp_clients {
--		bufnr = vim.api.nvim_get_current_buf(),
--		name = 'pyright',
--	}
--	for _, client in ipairs(clients) do
--		client.request('workspace/executeCommand', params, nil, 0)
--	end
--end
--
--local function set_python_path(path)
--	local clients = util.get_lsp_clients {
--		bufnr = vim.api.nvim_get_current_buf(),
--		name = 'pyright',
--	}
--	for _, client in ipairs(clients) do
--		if client.settings then
--			client.settings.python = vim.tbl_deep_extend('force', client.settings.python, { pythonPath = path })
--		else
--			client.config.settings = vim.tbl_deep_extend('force', client.config.settings, { python = { pythonPath = path } })
--		end
--		client.notify('workspace/didChangeConfiguration', { settings = nil })
--	end
--end

vim.lsp.start({
	name = 'pyright',
	cmd = { 'pyright-langserver', '--stdio' },
	root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = 'openFilesOnly',
			},
		},
	},
	--	commands = {
	--		PyrightOrganizeImports = {
	--			organize_imports,
	--			description = 'Organize Imports',
	--		},
	--		PyrightSetPythonPath = {
	--			set_python_path,
	--			description = 'Reconfigure pyright with the provided python path',
	--			nargs = 1,
	--			complete = 'file',
	--		},
	--	}
})
