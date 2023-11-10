-- Lazy nvim package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local lazy_file_events = { 'BufReadPost', 'BufNewFile', 'BufWritePre' }

local function lazy_file()
  local Event = require 'lazy.core.handler.event'
  Event.mappings.LazyFile = { id = 'LazyFile', event = 'User', pattern = 'LazyFile' }
  Event.mappings['User LazyFile'] = Event.mappings.LazyFile

  local events = {} ---@type {event: string, pattern?: string, buf: number, data?: any}[]

  local function load()
    if #events == 0 then
      return
    end
    vim.api.nvim_del_augroup_by_name 'lazy_file'

    ---@type table<string,string[]>
    local skips = {}
    for _, event in ipairs(events) do
      skips[event.event] = skips[event.event] or Event.get_augroups(event.event)
    end

    vim.api.nvim_exec_autocmds('User', { pattern = 'LazyFile', modeline = false })
    for _, event in ipairs(events) do
      Event.trigger {
        event = event.event,
        exclude = skips[event.event],
        data = event.data,
        buf = event.buf,
      }
      if vim.bo[event.buf].filetype then
        Event.trigger {
          event = 'FileType',
          buf = event.buf,
        }
      end
    end
    vim.api.nvim_exec_autocmds('CursorMoved', { modeline = false })
    events = {}
  end

  -- schedule wrap so that nested autocmds are executed
  -- and the UI can continue rendering without blocking
  load = vim.schedule_wrap(load)

  vim.api.nvim_create_autocmd(lazy_file_events, {
    group = vim.api.nvim_create_augroup('lazy_file', { clear = true }),
    callback = function(event)
      table.insert(events, event)
      load()
    end,
  })
end

lazy_file()

require('lazy').setup {
  spec = {
    { import = 'arthur.plugins' },
    { import = 'arthur.plugins.lsp' },
    { import = 'arthur.plugins.ui' },
    { import = 'arthur.plugins.coding' },
    { import = 'arthur.pde' },
  },
  defaults = { lazy = true, version = nil },
}
