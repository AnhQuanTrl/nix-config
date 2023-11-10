local Util = require 'arthur.util'

---@param bufnr number
local function register_lsp_keymaps(bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  local nvmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set({ 'v', 'n' }, keys, func, { buffer = bufnr, desc = desc })
  end

  local imap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('i', keys, func, { buffer = bufnr, desc = desc })
  end

  -- Go to ...
  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('gy', require('telescope.builtin').lsp_type_definitions, '[G]oto T[y]pe Definition')

  -- List symbols ...
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- Hover and signature
  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('gK', vim.lsp.buf.signature_help, 'Signature Documentation')
  imap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Rename, code actions
  nmap('<leader>cr', vim.lsp.buf.rename, 'Rename')
  nvmap('<leader>ca', vim.lsp.buf.code_action, 'Action')
  nmap('<leader>cl', vim.lsp.codelens.run, 'Codelens')

  -- Diagnostic keymaps
  nmap('<leader>cd', vim.diagnostic.open_float, 'Diagnostic')
  nmap(']d', vim.diagnostic.goto_next, 'Go to next diagnostic message')
  nmap('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic message')
end

return {
  {
    'neovim/nvim-lspconfig',
    event = 'LazyFile',
    dependencies = {
      'mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'folke/neodev.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    opts = {
      diagnostics = {
        underline = true,
        virtual_text = {
          source = 'if_many',
        },
        severity_sort = true,
      },
      servers = {},
      setup = {},
      actions = {},
    },
    config = function(_, opts)
      Util.format.register(Util.lsp.formatter())

      -- Attach keymap when lsp attach
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          register_lsp_keymaps(event.buf)
        end,
      })

      -- For dynamic capabilities
      local register_capability = vim.lsp.handlers['client/registerCapability']
      vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)
        local buffer = vim.api.nvim_get_current_buf()
        register_lsp_keymaps(buffer)
        return ret
      end

      -- Diagnostics
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- Inlay hint
      local inlay_hint = vim.lsp.inlay_hint
      Util.lsp.on_attach(function(client, buffer)
        if client.supports_method 'textDocument/inlayHint' then
          inlay_hint(buffer, true)
        end
      end)

      -- Codelens
      vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
        callback = function(event)
          local buf = event.buf
          local clients = vim.lsp.get_clients {
            bufnr = buf,
          }
          local supported_clients = vim.tbl_filter(function(client)
            return client.supports_method 'textDocument/codeLens'
          end, clients)
          if #supported_clients > 0 then
            vim.lsp.codelens.refresh()
          end
        end,
      })

      local servers = opts.servers
      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local function setup(server)
        local server_opts = vim.tbl_deep_extend('force', { capabilities = capabilities }, servers[server] or {})
        if opts.setup[server] then
          opts.setup[server](server, server_opts)
        end
        if opts.actions[server] then
          local actions = {}
          for _, action in ipairs(opts.actions[server]) do
            actions[#actions + 1] = { name = action, clientName = server }
          end
          Util.sourceaction.register(Util.lsp.sourceActions(actions))
        end

        require('lspconfig')[server].setup(server_opts)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          -- if servers_opt == true, use default LSP options
          server_opts = server_opts == true and {} or server_opts
          ensure_installed[#ensure_installed + 1] = server
        end
      end
      local mlsp = require 'mason-lspconfig'

      mlsp.setup {
        ensure_installed = ensure_installed,
      }
      mlsp.setup_handlers { setup }
    end,
  },
  {
    'jmederosalvarado/roslyn.nvim',
    dependencies = { 'nvim-lspconfig', 'cmp-nvim-lsp' },
    event = 'LazyFile',
    config = function()
      ---@type table|nil
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = false,
          },
        },
      })
      require('roslyn').setup {
        capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), capabilities),
        on_attach = function() end,
      }
    end,
  },
}
