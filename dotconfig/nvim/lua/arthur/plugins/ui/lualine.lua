local Util = require 'arthur.util'

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  opts = function()
    return {
      options = {
        theme = 'catppuccin',
        globalstatus = true,
      },
      sections = {
        lualine_x = {
          {
            function()
              return require('noice').api.status.mode.get()
            end,
            cond = function()
              return package.loaded['noice'] and require('noice').api.status.mode.has()
            end,
            color = Util.ui.fg 'Constant',
          },
          'filetype',
        },
      },
      extensions = { 'quickfix', 'nvim-tree', 'lazy' },
    }
  end,
}
