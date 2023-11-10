require 'arthur.core.options'
require 'arthur.core.lazy'

local Util = require 'arthur.util'

if vim.fn.argc(-1) == 0 then
  vim.api.nvim_create_autocmd('User', {
    group = vim.api.nvim_create_augroup('ArthurNvim', { clear = true }),
    pattern = 'VeryLazy',
    callback = function()
      Util.format.setup()
      require 'arthur.core.autocmds'
      require 'arthur.core.keymaps'
    end,
  })
else
  Util.format.setup()
  require 'arthur.core.autocmds'
  require 'arthur.core.keymaps'
end

-- For LSP Debugging
-- vim.lsp.set_log_level 'debug'
