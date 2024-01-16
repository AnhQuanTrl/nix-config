return {
  { 'b0o/SchemaStore.nvim', lazy = true, version = false },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'b0o/SchemaStore.nvim',
    },
    opts = {
      servers = {
        yamlls = {},
      },
      setup = {
        yamlls = function(_, opts)
          local cfg = require('yaml-companion').setup {
            builtin_matchers = {
              kubernetes = { enabled = true },
            },

            -- schemas available in Telescope picker
            schemas = {
              -- not loaded automatically, manually select with
              -- :Telescope yaml_schema
              {
                name = 'Argo CD Application',
                uri = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json',
              },
              {
                name = 'SealedSecret',
                uri = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/bitnami.com/sealedsecret_v1alpha1.json',
              },
            },

            lspconfig = {
              settings = {
                yaml = {
                  completion = true,
                },
              },
            },
          }
          require('lspconfig')['yamlls'].setup(cfg)
          return true
        end,
      },
    },
  },
  {
    'someone-stole-my-name/yaml-companion.nvim',
    lazy = true,
  },
}
