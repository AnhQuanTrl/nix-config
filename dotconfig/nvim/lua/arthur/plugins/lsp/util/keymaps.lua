local M = {}

---@type LazyKeysLspSpec[]|nil
M._keys = nil

---@alias LazyKeysLspSpec LazyKeysSpec|{has?:string}
---@alias LazyKeysLsp LazyKeys|{has?:string}
-- nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
-- nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
-- nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
-- nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
-- nmap('gy', require('telescope.builtin').lsp_type_definitions, '[G]oto T[y]pe Definition')
--
-- -- List symbols ...
-- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
-- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
--
-- -- Hover and signature
-- -- See `:help K` for why this keymap
-- nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
-- nmap('gK', vim.lsp.buf.signature_help, 'Signature Documentation')
-- imap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
--
-- -- Rename, code actions
-- nmap('<leader>cr', vim.lsp.buf.rename, 'Rename')
-- nvmap('<leader>ca', vim.lsp.buf.code_action, 'Action')
-- nmap('<leader>cl', vim.lsp.codelens.run, 'Codelens')
--
-- -- Diagnostic keymaps
-- nmap('<leader>cd', vim.diagnostic.open_float, 'Diagnostic')
-- nmap(']d', vim.diagnostic.goto_next, 'Go to next diagnostic message')
-- nmap('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic message')

---@return LazyKeysLspSpec[]
function M.get()
  if M._keys then
    return M._keys
  end

  M._keys = {
    {
      'gd',
      function()
        require('telescope.builtin').lsp_definitions { reuse_win = true }
      end,
      desc = 'Goto Definition',
      has = 'definition',
    },
    { 'gr', '<cmd>Telescope lsp_references<cr>', desc = 'References' },
    { 'gD', vim.lsp.buf.declaration, desc = 'Goto Declaration' },
    {
      'gI',
      function()
        require('telescope.builtin').lsp_implementations { reuse_win = true }
      end,
      desc = 'Goto Implementation',
    },
    {
      'gy',
      function()
        require('telescope.builtin').lsp_type_definitions { reuse_win = true }
      end,
      desc = 'Goto T[y]pe Definition',
    },
    { 'K', vim.lsp.buf.hover, desc = 'Hover' },
    { 'gK', vim.lsp.buf.signature_help, desc = 'Signature Help' },
    { '<c-k>', vim.lsp.buf.signature_help, mode = 'i', desc = 'Signature Help' },
    { '<leader>ca', vim.lsp.buf.code_action, desc = 'Code Action', mode = { 'n', 'v' } },
    { '<leader>cl', vim.lsp.codelens.run, desc = 'Codelens' },
    { '<leader>cr', vim.lsp.buf.rename, desc = 'Rename' },
  }
  return M._keys
end

---@param method string
function M.has(buffer, method)
  method = method:find '/' and method or 'textDocument/' .. method
  local clients = require('arthur.util').lsp.get_clients { bufnr = buffer }
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

---@return (LazyKeys|{has?:string})[]
function M.resolve(buffer)
  local Keys = require 'lazy.core.handler.keys'
  if not Keys.resolve then
    return {}
  end
  local spec = M.get()
  local opts = require('arthur.util').opts 'nvim-lspconfig'
  local clients = require('arthur.util').lsp.get_clients { bufnr = buffer }
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

function M.on_attach(_, buffer)
  local Keys = require 'lazy.core.handler.keys'
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    if not keys.has or M.has(buffer, keys.has) then
      local opts = Keys.opts(keys)
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or 'n', keys.lhs, keys.rhs, opts)
    end
  end
end

return M
