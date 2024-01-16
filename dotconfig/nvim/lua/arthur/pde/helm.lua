return {
  { 'towolf/vim-helm', ft = 'helm' },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        helm_ls = {
          settings = {
            ['helm-ls'] = {
              yamlls = {
                path = vim.fn.stdpath 'data' .. '/mason/bin/yaml-language-server',
                config = {
                  schemas = {
                    kubernetes = '**',
                  },
                  completion = true,
                  hover = true,
                  -- any other config: https://github.com/redhat-developer/yaml-language-server#language-server-settings
                },
              },
            },
          },
        },
      },
    },
  },
}
