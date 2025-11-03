local M = {}

local config = {
  python_venv_dir = vim.fn.expand("~/Development/DevTools/PyEnvs"),
}


M.definition_split = function()
  vim.lsp.buf.definition({
    on_list = function(options)
      -- if there are multiple items, warn the user
      if #options.items > 1 then
        vim.notify("Multiple items found, opening first one", vim.log.levels.WARN)
        vim.lsp.buf.definition()
      else
        local win_count = #vim.api.nvim_tabpage_list_wins(0)
        if win_count == 1 then
          local item = options.items[1]
          local cmd = "vsplit +" .. item.lnum .. " " .. item.filename .. "|" .. "normal " .. item.col .. "|"
          vim.cmd(cmd)
        else
          vim.lsp.buf.definition()
        end
      end
    end
  })
end

------------------------------------------------------
-- LSP Configs
-- See :h lsp-quickstart for more details
------------------------------------------------------
local function setup_lspconfig()


end
------------------------------------------------------
-- Autocommands for LSP
------------------------------------------------------
local function setup_autocommands_lsp()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
      local buf = ev.buf
      local opts = { buffer = buf, silent = true }

      -- Do NOT show by default
      local diagnostics_active = true

      local function toggle_diagnostics()
        diagnostics_active = not diagnostics_active
        if diagnostics_active then
          vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
          })
          print("Diagnostics enabled")
        else
          vim.diagnostic.config({
            virtual_text = false,
            signs = false,
            underline = false,
          })
          print("Diagnostics disabled")
        end
      end

      function definition_split()
        vim.lsp.buf.definition({
          on_list = function(options)
            -- if there are multiple items, warn the user
            if #options.items > 1 then
              vim.notify("Multiple items found, opening first one", vim.log.levels.WARN)
              vim.lsp.buf.definition()
            else
              local win_count = #vim.api.nvim_tabpage_list_wins(0)
              if win_count == 1 then
                local item = options.items[1]
                local cmd = "vsplit +" .. item.lnum .. " " .. item.filename .. "|" .. "normal " .. item.col .. "|"
                vim.cmd(cmd)
              else
                vim.lsp.buf.definition()
              end
            end
          end
        })
      end

      vim.keymap.set("n", "gd", function() M.definition_split() end, opts)
      -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
      -- vim.keymap.set("n", "gs", vim.lsp.buf.document_symbol, opts)
      vim.keymap.set("n", "gs", "<cmd>FzfLua lsp_document_symbols<cr>", opts)
      -- vim.keymap.set("n", "tj", "<cmd>Trouble diagnostics toggle<cr>", opts)
      vim.keymap.set("n", "et", toggle_diagnostics, opts)

      local border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      }

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = border }
      )
    end,
  })
end


------------------------------------------------------
-- Plugin: venv-selector
------------------------------------------------------
local function setup_plugin_venv_selector_python()
  require("venv-selector").setup({
    enable_default_searches = false,
    search = {
      default = {
        command="rg --files --glob '**/python' --follow " .. config.python_venv_dir
      }
    },
  })
end

------------------------------------------------------
-- Plugin: Navic: Breadcrumbs
------------------------------------------------------
local function setup_plugin_navic()
  require('nvim-navic').setup({
      lsp = {
          auto_attach = true,
          preference = nil,
      },
  })
end
------------------------------------------------------
-- Plugin: Trouble
------------------------------------------------------
local function setup_plugin_trouble()
  require('trouble').setup({
    win = {
      position = "right",
      size = 100,
    },
  })
end
------------------------------------------------------
-- Plugin: Mason
------------------------------------------------------
local function setup_plugin_mason()
  require('mason').setup()
  require('mason-lspconfig').setup()
  require('mason-tool-installer').setup({
    ensure_installed = {
      "lua_ls",
      "stylua",
      "pyright"
    }
  })
end
------------------------------------------------------
-- Plugin: Blink cmp
------------------------------------------------------
local function setup_plugin_blink_cmp()
  -- Blink
  -- Keymaps (Default) https://cmp.saghen.dev/modes/cmdline.html
  -- ctrl+n: Select next | ctrl+p: Select prev | ctrl+y: Accept
  require('blink.cmp').setup({
    fuzzy = {
      implementation = "lua"
    },
    completion = {
      menu = {
        border = "rounded",
      },
      documentation = {
        window = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
        },
        auto_show = false,
      },
    },
    keymap = {
      preset = 'none',
      ['<C-i>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<C-Enter>'] = { 'select_and_accept', 'fallback' },
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },
      ['<C-k>'] = { 'select_prev', 'fallback_to_mappings' },
      ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
      -- ['<Tab>'] = { 'snippet_forward', 'fallback' },
      -- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      ['<C-g>'] = { 'show_signature', 'hide_signature', 'fallback' },
      ['<Tab>'] = {
        function(cmp)
          if cmp.snippet_active() then return cmp.accept()
          else return cmp.select_and_accept() end
        end,
        'snippet_forward',
        'fallback'
      },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
    }
  })
end
------------------------------------------------------
-- Plugin: Hover
------------------------------------------------------
local function setup_plugin_hover()
  require('hover').config({
    --- List of modules names to load as providers.
    --- @type (string|Hover.Config.Provider)[]
    providers = {
      'hover.providers.diagnostic',
      'hover.providers.lsp',
      'hover.providers.dap',
      'hover.providers.man',
      'hover.providers.dictionary',
      -- Optional, disabled by default:
      -- 'hover.providers.gh',
      -- 'hover.providers.gh_user',
      -- 'hover.providers.jira',
      -- 'hover.providers.fold_preview',
      -- 'hover.providers.highlight',
    },
    preview_opts = {
      border = 'single'
    },
    -- Whether the contents of a currently open hover window should be moved
    -- to a :h preview-window when pressing the hover keymap.
    preview_window = false,
    title = true,
    mouse_providers = {
      'hover.providers.lsp',
    },
    mouse_delay = 1000
  })

  vim.keymap.set('n', 'K', function() require('hover').open() end, { desc = 'hover.nvim (open)' })
  -- Use this to enter the documentation in normal mode for movement
  vim.keymap.set('n', 'gK', function() require('hover').enter() end, { desc = 'hover.nvim (enter)' })

end
------------------------------------------------------
-- Plugin: nvim-treesitter
------------------------------------------------------
local function setup_plugin_nvim_treesitter()
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      "bash",
      "c",
      "cmake",
      "cpp",
      "dockerfile",
      "groovy",
      "go",
      "java",
      "javascript",
      "jsonnet",
      "just",
      "lua",
      "make",
      "markdown",
      "markdown_inline",
      "meson",
      "python",
      "rust",
      "terraform",
      "toml",
      "typescript",
      "vue",
      "yaml",
      "zig"
    },
    highlight = { enable = true },
    indent = { enable = true },
  })
end

------------------------------------------------------
-- Setup
------------------------------------------------------
function M.setup(opts)
  opts = opts or {}
  config.python_venv_dir = opts.python_venv_dir or config.python_venv_dir
  setup_plugin_navic()
  setup_plugin_hover()
  setup_plugin_nvim_treesitter()
  setup_plugin_mason()
  setup_plugin_trouble()
  setup_plugin_blink_cmp()
  setup_autocommands_lsp()
  setup_plugin_venv_selector_python()
end

return M
