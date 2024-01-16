return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'javascript', 'typescript', 'tsx' })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        tsserver = {
          keys = {
            {
              '<leader>co',
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { 'source.organizeImports.ts' },
                    diagnostics = {},
                  },
                }
              end,
              desc = 'Organize Imports',
            },
            {
              '<leader>cR',
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { 'source.removeUnused.ts' },
                    diagnostics = {},
                  },
                }
              end,
              desc = 'Remove Unused Imports',
            },
          },
          settings = {
            typescript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
      },
      setup = {},
    },
    {
      'williamboman/mason.nvim',
      opts = function(_, opts)
        table.insert(opts.ensure_installed, 'prettier')
      end,
    },
    {
      'stevearc/conform.nvim',
      optional = true,
      opts = {
        formatters_by_ft = {
          ['javascript'] = { 'prettier' },
          ['javascriptreact'] = { 'prettier' },
          ['typescript'] = { 'prettier' },
          ['typescriptreact'] = { 'prettier' },
          ['vue'] = { 'prettier' },
          ['css'] = { 'prettier' },
          ['scss'] = { 'prettier' },
          ['less'] = { 'prettier' },
          ['html'] = { 'prettier' },
          ['json'] = { 'prettier' },
          ['jsonc'] = { 'prettier' },
          ['yaml'] = { 'prettier' },
          ['markdown'] = { 'prettier' },
          ['markdown.mdx'] = { 'prettier' },
          ['graphql'] = { 'prettier' },
          ['handlebars'] = { 'prettier' },
        },
      },
    },
  },
}
