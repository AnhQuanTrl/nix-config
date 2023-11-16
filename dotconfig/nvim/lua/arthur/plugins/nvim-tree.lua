return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<leader>fe', '<cmd>NvimTreeFindFileToggle<cr>', desc = '[F]ile [E]xplorer' },
  },
  opts = {
    git = {
      ignore = false,
    },
    view = {
      width = 30,
    },
  },
  config = function(_, opts)
    local nvimtree = require 'nvim-tree'
    nvimtree.setup(opts)
  end,
}
