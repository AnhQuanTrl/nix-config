return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'nix' })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        nil_ls = {
          mason = false,
          settings = {
            ['nil'] = {},
          },
        },
      },
      setup = {},
    },
  },
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = {
      formatters_by_ft = {
        nix = { 'alejandra' },
      },
    },
  },
}
