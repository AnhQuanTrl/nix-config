return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    options = {
      theme = 'catppuccin',
      globalstatus = true,
    },
    extensions = { 'quickfix', 'nvim-tree', 'lazy' },
  },
}
