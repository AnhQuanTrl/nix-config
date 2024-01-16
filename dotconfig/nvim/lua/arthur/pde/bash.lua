return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'bash' })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        bashls = {
          settings = {
            bashIde = {
              shellcheckPath = vim.fn.stdpath 'data' .. '/mason/bin/shellcheck',
              explainshellEndpoint = 'http://localhost:5000',
            },
          },
        },
      },
    },
  },
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      table.insert(opts.ensure_installed, 'shellcheck')
    end,
  },
}
