local Util = require 'arthur.util'

local function map(mode, lhs, rhs, opts)
  local options = { silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Make spac a <Nop> key as it is used for <leader>
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Move to window using the <ctrl> hjkl keys
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })

-- Move Lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })

-- Better vertical navigation
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

--- formatting
map('n', '<leader>cf', function()
  Util.format { force = true }
end, { desc = 'Format' })

-- toggle options
map('n', '<leader>uf', function()
  Util.format.toggle()
end, { desc = 'Toggle auto format (global)' })
map('n', '<leader>uF', function()
  Util.format.toggle(true)
end, { desc = 'Toggle auto format (buffer)' })
map('n', '<leader>uh', function()
  vim.lsp.inlay_hint(0, nil)
end, { desc = 'Toggle Inlay Hint' })
