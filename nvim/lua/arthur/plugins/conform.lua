local Util = require 'arthur.util'

return {
  {
    'stevearc/conform.nvim',
    dependencies = { 'mason.nvim' },
    lazy = true,
    cmd = 'ConformInfo',
    keys = {
      {
        '<leader>cF',
        function()
          require('conform').format { formatters = { 'injected' } }
        end,
        mode = { 'n', 'v' },
        desc = 'Format Injected Langs',
      },
    },
    init = function()
      require('arthur.util').on_very_lazy(function()
        require('arthur.util').format.register {
          name = 'conform.nvim',
          priority = 100,
          format = function(buf)
            local opts = Util.opts 'conform.nvim'
            require('conform').format(Util.merge(opts.format, { bufnr = buf }))
          end,
          sources = function(buf)
            local ret = require('conform').list_formatters(buf)
            ---@param v conform.FormatterInfo
            return vim.tbl_map(function(v)
              return v.name
            end, ret)
          end,
        }
      end)
    end,
    opts = function()
      ---@class ConformOpts
      local opts = {
        format = {
          timeout_ms = 3000,
          async = false,
          quiet = false,
        },
        ---@type table<string, conform.FormatterUnit[]>
        formatters_by_ft = {
          sh = { 'shfmt' },
        },
        formatters = {
          injected = { options = { ignore_errors = true } },
        },
      }

      return opts
    end,
    config = function(_, opts)
      require('conform').setup(opts)
    end,
  },
}
