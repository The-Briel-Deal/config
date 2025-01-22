local M = {}

M.setup = function(opts)
  require("oil").setup {
      default_file_explorer = true,
      columns = {
        "permission",
        "size",
        "mtime",
      },
  }
end

return M
