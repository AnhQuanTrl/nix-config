return {
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'LazyFile',
    opts = {
      indent = {
        char = '│',
        tab_char = '│',
      },
      scope = { enabled = false },
    },
    main = 'ibl',
  },
  {
    'echasnovski/mini.indentscope',
    event = 'LazyFile',
    opts = {
      -- symbol = "▏",
      symbol = '│',
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'help',
          'NvimTree',
          'lazy',
          'mason',
          'notify',
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
}
