local Util = require 'arthur.util'

---@class arthur.util.sourceaction
local M = {}

---@class LazySourceAction
---@field name string
---@field source string
---@field action fun(bufnr:number)
---@field priority number
---@field active fun(bufnr:number):boolean

M.actions = {} ---@type LazySourceAction[]

---@param actions LazySourceAction[]
function M.register(actions)
  vim.list_extend(M.actions, actions)
  table.sort(M.actions, function(a, b)
    return a.priority > b.priority
  end)
end

function M.enabled()
  return vim.g.autoaction == nil or vim.g.autoaction
end

---@param buf? number
function M.apply(buf)
  if not M.enabled() then
    return
  end

  buf = buf or vim.api.nvim_get_current_buf()
  for _, action in ipairs(M.actions) do
    if action.active(buf) then
      Util.try(function()
        return action.action(buf)
      end, { msg = 'Source action `' .. action.name .. ' from ' .. action.source .. '` failed' })
    end
  end
end

function M.setup()
  -- Autoformat autocmd
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('LazySourceAction', {}),
    callback = function(event)
      M.apply(event.buf)
    end,
  })
end

return M
