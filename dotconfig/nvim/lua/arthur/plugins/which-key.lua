return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = function()
    local options = {
      plugins = { spelling = true },
      defaults = {
        mode = { 'n', 'v' },
        ['<leader>s'] = { name = '[S]earch' },
        ['<leader>f'] = { name = '[F]iles/[F]ind' },
        ['<leader>u'] = { name = '[U]I' },
        ['<leader>c'] = { name = '+[C]ode' },
      },
    }
    if require('arthur.util').has 'noice.nvim' then
      options.defaults['<leader>sn'] = { name = '[N]oice' }
    end

    return options
  end,
  config = function(_, opts)
    local wk = require 'which-key'
    wk.setup(opts)

    wk.register(opts.defaults)
  end,
}
