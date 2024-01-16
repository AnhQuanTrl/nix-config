local Util = require 'arthur.util'

return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  cmd = 'Telescope',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  opts = function()
    -- local actions = require 'telescope.actions'
    return {}
  end,
  keys = {
    { '<leader>?', '<cmd>Telescope oldfiles<cr>', desc = '[?] Find recently opened files' },
    { '<leader><space>', '<cmd>Telescope buffers show_all_buffers=true<cr>', desc = '[ ] Find existing buffers' },
    {
      '<leader>/',
      function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end,
      desc = '[/] Fuzzily search in current buffer',
    },
    {
      '<leader>:',
      function()
        require('telescope.builtin').command_history(require('telescope.themes').get_ivy())
      end,
      desc = '[:] Search command histories',
    },

    -- Files/Find
    { '<leader>fb', '<cmd>Telescope buffers show_all_buffers=true<cr>', desc = '[F]ind existing [b]uffers' },
    { '<leader>ff', Util.telescope 'files', desc = '[F]ind [F]iles' },
    { '<leader>fr', Util.telescope('oldfiles', { only_cwd = true }), desc = '[F]ind [r]ecently opened files (cwd)' },
    -- Search
    { '<leader>sh', '<cmd>Telescope help_tags<cr>', desc = '[S]earch [H]elp' },
    { '<leader>sd', '<cmd>Telescope diagnostics<cr>', desc = '[S]earch [D]iagnostics' },
    { '<leader>sw', '<cmd>Telescope grep_string<cr>', desc = '[S]earch current [W]ord' },
    { '<leader>sw', '<cmd>Telescope grep_string<cr>', mode = 'v', desc = '[S]earch selected [w]ord' },
    { '<leader>sg', '<cmd>Telescope live_grep<cr>', desc = '[S]earch by [G]rep' },
    { '<leader>sr', '<cmd>Telescope resume<cr>', desc = '[S]earch [R]esume' },
  },
  config = function(_, opts)
    local telescope = require 'telescope'
    telescope.setup(opts)
    telescope.load_extension 'fzf'
    if Util.has 'yaml-companion' then
      telescope.load_extension 'yaml_schema'
    end
  end,
}
