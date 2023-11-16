return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'go', 'gomod', 'gosum', 'gowork' })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = {
                appends = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
                printf = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              gofumpt = true,
              semanticTokens = true,
              symbolScope = 'workspace',
              directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
              -- buildFlags = { '-tags=tools' },
            },
          },
        },
        bufls = {},
      },
      actions = {
        gopls = {
          'source.organizeImports',
        },
      },
    },
  },
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'gofumpt', 'golangci-lint' })
    end,
  },
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = {
      formatters_by_ft = {
        go = { 'gofumpt' },
      },
    },
  },
  {
    'mfussenegger/nvim-lint',
    optional = true,
    opts = {
      linters_by_ft = {
        go = { 'golangcilint' },
      },
      linters = {
        golangcilint = {
          args = {
            'run',
            '--out-format',
            'json',
            '--disable',
            'unused',
            '--disable',
            'govet',
            function()
              return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h')
            end,
          },
        },
      },
    },
  },
}
