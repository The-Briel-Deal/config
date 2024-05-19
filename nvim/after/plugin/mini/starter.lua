-- Mini starter
local starter = require("mini.starter")

starter.setup({
	content_hooks = {
		starter.gen_hook.adding_bullet(""),
		starter.gen_hook.aligning("center", "center"),
	},
	evaluate_single = true,
	footer = os.date(),
	header = table.concat({
		[[  /\ \▔\___  ___/\   /(●)_ __ ___  ]],
		[[ /  \/ / _ \/ _ \ \ / / | '_ ` _ \ ]],
		[[/ /\  /  __/ (_) \ V /| | | | | | |]],
		[[\_\ \/ \___|\___/ \_/ |_|_| |_| |_|]],
		[[───────────────────────────────────]],
	}, "\n"),
	query_updaters = [[abcdefghilmoqrstuvwxyz0123456789_-,.ABCDEFGHIJKLMOQRSTUVWXYZ]],
	items = {
		starter.sections.telescope(),
		starter.sections.recent_files(10, false),
		starter.sections.telescope,
		{ action = "Explore ~/.config", name = "C: Dot Files",      section = "Dirs" },
		{ action = "Lazy update",       name = "U: Update Plugins", section = "Plugins" },
		{ action = "enew",              name = "E: New Buffer",     section = "Builtin actions" },
		{ action = "qall!",             name = "Q: Quit Neovim",    section = "Builtin actions" },
	},
})

vim.cmd([[
  augroup MiniStarterJK
    au!
    au User MiniStarterOpened nmap <buffer> j <Cmd>lua MiniStarter.update_current_item('next')<CR>
    au User MiniStarterOpened nmap <buffer> k <Cmd>lua MiniStarter.update_current_item('prev')<CR>
  augroup END
]])
