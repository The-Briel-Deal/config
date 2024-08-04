-- Undo Tree for going back through undos and redos
return {
	"mbbill/undotree",
	event = "BufEnter",
	keys = {
		{ "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle UndoTree" },
	}
}
