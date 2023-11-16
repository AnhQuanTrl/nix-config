---@class arthur.util.telescope
---@overload fun(builtin:string, opt?:table)
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.telescope(...)
  end,
})

---@param builtin string
---@param opts? table
function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    if builtin == 'files' then
      if vim.loop.fs_stat(vim.loop.cwd() .. './git') then
        opts.show_untracked = true
        builtin = 'git_files'
      else
        builtin = 'find_files'
      end
    end

    require('telescope.builtin')[builtin](opts)
  end
end

return M
