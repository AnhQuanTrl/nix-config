return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'lua', 'luadoc', 'luap' })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'folke/neodev.nvim' },
    },
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = 'Disable',
              },
              telemetry = { enable = false },
              hint = {
                enable = true,
                setType = true,
              },
            },
          },
        },
      },
      setup = {
        lua_ls = function(_, _)
          require('neodev').setup()
        end,
      },
    },
  },
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'stylua' })
    end,
  },
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
      },
    },
  },
}
