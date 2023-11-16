local Util = require 'arthur.util'

---@class arthur.util.lsp
local M = {}

---@alias lsp.Client.filter {id?: number, bufnr?: number, name?: string, method?: string, filter?:fun(client: lsp.Client):boolean}

---@param opts? lsp.Client.filter
function M.get_clients(opts)
  local ret = {} ---@type lsp.Client
  ret = vim.lsp.get_clients(opts)
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@param on_attach fun(client:lsp.Client, buffer:number)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

---@param from string
---@param to string
function M.on_rename(from, to)
  local clients = M.get_clients()
  for _, client in ipairs(clients) do
    if client.supports_method 'workspace/willRenameFiles' then
      ---@diagnostic disable-next-line: invisible
      local resp = client.request_sync('workspace/willRenameFiles', {
        files = {
          {
            oldUri = vim.uri_from_fname(from),
            newUri = vim.uri_from_fname(to),
          },
        },
      }, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end
end

---@param opts? LazyFormatter| {filter?: (string|lsp.Client.filter)}
function M.formatter(opts)
  opts = opts or {}
  local filter = opts.filter or {}
  filter = type(filter) == 'string' and { name = filter } or filter
  ---@cast filter lsp.Client.filter
  ---@type LazyFormatter
  local ret = {
    name = 'LSP',
    priority = 1,
    format = function(buf)
      M.format(Util.merge(filter, { bufnr = buf }))
    end,
    sources = function(buf)
      local clients = M.get_clients(Util.merge(filter, { bufnr = buf }))
      ---@param client lsp.Client
      local ret = vim.tbl_filter(function(client)
        return client.supports_method 'textDocument/formatting' or client.supports_method 'textDocument/rangeFormatting'
      end, clients)
      ---@param client lsp.Client
      return vim.tbl_map(function(client)
        return client.name
      end, ret)
    end,
  }
  return Util.merge(ret, opts) --[[@as LazyFormatter]]
end

---@alias lsp.Client.format {timeout_ms?: number, formatting_options?: table} | lsp.Client.filter

---@param opts? lsp.Client.format
function M.format(opts)
  opts = vim.tbl_deep_extend('force', {}, opts or {}, require('arthur.util').opts('nvim-lspconfig').format or {})
  return vim.lsp.buf.format(opts)
end

---@param actions { name: string, clientName: string }[]
function M.sourceActions(actions)
  ---@type LazySourceAction[]
  local ret = {}
  for index, action in ipairs(actions) do
    local name = action.name
    ret[#ret + 1] = {
      source = 'LSP',
      name = name,
      action = function(buf)
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { name } }
        local result = vim.lsp.buf_request_sync(buf, 'textDocument/codeAction', params)
        for cid, res in pairs(result or {}) do
          for _, r in pairs(res.result or {}) do
            if r.edit then
              local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
              vim.lsp.util.apply_workspace_edit(r.edit, enc)
            end
          end
        end
      end,
      priority = 1 + index,
      active = function(buf)
        local clients = M.get_clients { bufnr = buf, name = action.clientName }
        return #vim.tbl_filter(function(client)
          return client.supports_method 'textDocument/codeAction'
        end, clients) > 0
      end,
    }
  end

  return ret
end

return M
