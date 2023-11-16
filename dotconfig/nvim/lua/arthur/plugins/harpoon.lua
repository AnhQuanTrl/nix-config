return {
  'ThePrimeagen/harpoon',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  event = 'VeryLazy',
  config = function()
    local mark = require 'harpoon.mark'
    local ui = require 'harpoon.ui'

    ---@param keys string
    ---@param func fun():any
    ---@param desc string
    ---@param opt? table
    local nmap = function(keys, func, desc, opt)
      local options = { desc = desc }
      opt = opt or {}
      options = vim.tbl_deep_extend('force', options, opt) or {}

      if desc then
        desc = 'Harpoon: ' .. desc
      end

      vim.keymap.set('n', keys, func, options)
    end

    nmap('gh', function()
      if vim.v.count > 0 then
        return '<cmd>lua require("harpoon.ui").nav_file(vim.v.count) <CR>'
      else
        mark.toggle_file()
      end
    end, 'Add file', { expr = true })
    nmap('gH', ui.toggle_quick_menu, 'Toggle quick menu')
  end,
}
