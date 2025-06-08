local M = {}

M.setup = function(opts)
  -- KEYBINDS --
  -- Set Leader Key as Spacebar.
  vim.g.mapleader = ' '

  local set = vim.keymap.set

  -- Set lead-c as the command to close current split.
  set('n', '<leader>c', vim.cmd.close)
  -- Use lead to move between windows.
  set('n', '<leader>h', function()
    vim.cmd.wincmd('h')
  end)
  set('n', '<leader>j', function()
    vim.cmd.wincmd('j')
  end)
  set('n', '<leader>k', function()
    vim.cmd.wincmd('k')
  end)
  set('n', '<leader>l', function()
    vim.cmd.wincmd('l')
  end)

  -- Open new Daily Note.
  set('n', '<leader>nd', function()
    local template_path = '~/Notes/Templates/nvim-daily-note.md'
    local daily_note_path = '~/Notes/Daily/' .. vim.fn.strftime('%Y-%m-%d') .. '.md'
    if vim.fn.empty(vim.fn.glob(vim.fn.expand(daily_note_path))) == 1 then
      os.execute('cp ' .. template_path .. ' ' .. daily_note_path)
    end
    vim.cmd.edit(daily_note_path)
  end)

  -- Open Kratom Log.
  set('n', '<leader>nk', function()
    vim.cmd.edit('~/Notes/Log/Kratom/' .. vim.fn.strftime('%Y-%m-%d') .. '.md')
  end)

  -- OIL KEYMAP --
  if package.loaded['oil'] then
    local oil = require 'oil'
    set('n', '<leader>pv', oil.open)
  end

  -- FUGITIVE KEYMAP --
  set('n', '<leader>gs', vim.cmd.Git)

  -- TELESCOPE KEYMAP --
  ---@type {key: string, callback: fun(), desc: string}[]
  local telescope_keymap = {
    {
      key = '<leader>ff',
      callback = function()
        require('telescope.builtin').find_files()
      end,
      desc = 'Find Files',
    },
    {
      key = '<leader>fs',
      callback = function()
        require('telescope.builtin').live_grep()
      end,
      desc = 'Find Files',
    },
    {
      key = '<leader>fg',
      callback = function()
        require('telescope.builtin').git_files({ use_file_path = true })
      end,
      desc = 'Find Files in Git',
    },
    {
      key = '<leader>fh',
      callback = function()
        require('telescope.builtin').help_tags()
      end,
      desc = 'Find Nvim Help Docs',
    },
    {
      key = '<leader>fc',
      callback = function()
        require('telescope.builtin').find_files({ cwd = '~/.config' })
      end,
      desc = 'Find Files in my .config Dir',
    },
    {
      key = '<leader>fn',
      callback = function()
        require('telescope.builtin').find_files({ cwd = '~/Notes' })
      end,
      desc = 'Find Files in my Notes Dir',
    },
    {
      key = '<leader>fC',
      callback = function()
        require('telescope.builtin').find_files({ cwd = '~/Code' })
      end,
      desc = 'Find Files in my Code Dir',
    },
    {
      key = '<leader>f/',
      callback = function()
        require('telescope.builtin').current_buffer_fuzzy_find()
      end,
      desc = 'Find Line in Current Buffer',
    },
    {
      key = '<leader>fo',
      callback = function()
        require('telescope.builtin').oldfiles()
      end,
      desc = 'Find File in my File History',
    },
    {
      key = '<leader>fb',
      callback = function()
        require('telescope.builtin').buffers()
      end,
      desc = 'Find Buffer in open Buffers',
    },
  }
  for _, keymap in ipairs(telescope_keymap) do
    set('n', keymap.key, keymap.callback, { desc = keymap.desc })
  end
end

return M
