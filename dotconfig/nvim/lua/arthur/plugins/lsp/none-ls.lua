return {
  'nvimtools/none-ls.nvim',
  event = 'LazyFile',
  dependencies = { 'mason.nvim' },
  opts = function()
    return {
      root_dir = require('null-ls.utils').root_pattern('.null-ls-root', '.neoconf.json', 'Makefile', '.git'),
      sources = {},
    }
  end,
}
