-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Configure clipboard
-- if vim.fn.has 'wsl' then
--   vim.g.clipboard = {
--     name = 'WslClipboard',
--     copy = {
--       ['+'] = 'clip.exe',
--       ['*'] = 'clip.exe',
--     },
--     paste = {
--       ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--       ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--     },
--     cache_enabled = false,
--   }
-- end

-- line numbers
vim.opt.number = true -- shows absolute line number on cursor line
vim.opt.relativenumber = true -- show relative line numbers

-- mouse
vim.opt.mouse = 'a'

-- indent
vim.opt.breakindent = true

-- undo history
vim.opt.undofile = true

-- / search
vim.opt.hlsearch = false -- disable highlight on search as it is quite distracting
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- signcolumn / gutter
vim.opt.signcolumn = 'yes'

-- update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- completion
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- theme
vim.opt.termguicolors = true
vim.opt.fillchars:append 'eob: '

-- format
vim.g.autoformat = true
vim.g.autoaction = true

vim.g.mapleader = ' '
vim.g.maplocalleader = ','
