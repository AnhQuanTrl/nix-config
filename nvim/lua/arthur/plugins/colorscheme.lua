return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  opts = {
    flavour = 'mocha',
    integrations = {
      cmp = true,
      mason = true,
      telescope = {
        enabled = true,
      },
      which_key = true,
      noice = true,
      notify = true,
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { 'italic' },
          hints = { 'italic' },
          warnings = { 'italic' },
          information = { 'italic' },
        },
        underlines = {
          errors = { 'underline' },
          hints = { 'underline' },
          warnings = { 'underline' },
          information = { 'underline' },
        },
        inlay_hints = {
          background = true,
        },
      },
    },
  },
  config = function(_, opts)
    local theme = require 'catppuccin'
    theme.setup(opts)
    vim.cmd.colorscheme 'catppuccin'
  end,
}
