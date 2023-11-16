local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd('BufEnter', {
  desc = 'Open Nvim-tree on startup with directory',
  group = augroup('nvimtree_start', { clear = true }),
  callback = function()
    if package.loaded['nvim-tree'] then
      vim.api.nvim_del_augroup_by_name 'nvimtree_start'
    else
      local stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
      if stats and stats.type == 'directory' then
        vim.api.nvim_del_augroup_by_name 'nvimtree_start'
        require('nvim-tree.api').tree.open()
      end
    end
  end,
})
