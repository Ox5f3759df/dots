local M = {}

M.config = {
  -- Directory to find Python Environments
  python_venv_dir = vim.fn.expand("~/Development/DevTools/PyEnvs"),
  -- Ensure installed mason lsp environments
  mason_ensure_installed = {
      "lua_ls",
      "stylua",
      "pyright",
      "rust-analyzer",
      "json-lsp",
      -- "jdlts", -- java (21+ only)
      -- "gopls", -- go
      -- "kotlin-lsp", -- doesn't really work
  },
  treesitter_ensure_installed = {
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
  }
}

local kmap = vim.keymap.set
local kopts = function(x, buf)
  if buf ~= nil then
    return { noremap = true, silent = true, desc = x or "", buffer = buf }
  end
  return { noremap = true, silent = true, desc = x or "" }
end

local function setup_lspconfig_rust()
  -- See: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/rust_analyzer.lua
  -- See: https://www.reddit.com/r/neovim/comments/1kk4s0u/how_to_configure_rustanalyzer_using_vimlspconfig/
  -- vim.lsp.config.rust_analyzer = {
  --     on_attach = on_attach,
  --     capabilities = capabilities,
  --     cmd = { 'rust-analyzer' },
  --     filetypes = { 'rust' },
  --     root_markers = {"rust-project.json", "Cargo.toml", ".git"},
  --     single_file_support = true,
  --     settings = {
  --         ['rust-analyzer'] = {
  --             diagnostics = {
  --                 enable = false;
  --             }
  --         }
  --     },
  --     before_init = function(init_params, config)
  --         -- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
  --         if config.settings and config.settings['rust-analyzer'] then
  --             init_params.initializationOptions = config.settings['rust-analyzer']
  --         end
  --     end,
  -- }
end

local function setup_autocommands_lsp()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
      local buf = ev.buf
      local opts = { buffer = buf, silent = true }

      local diagnostics_active = true

      local function toggle_diagnostics()
        diagnostics_active = diagnostics_active
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

      -- Display inlay hints if supported
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { bufnr = 0 })

      -- Open gd in split if no split buffers present
      kmap("n", "gd", function() M.definition_split() end,        kopts('LSP: Definition Split'))
      -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      kmap("n", "gD", vim.lsp.buf.declaration,                    kopts('LSP: Declaration'))
      kmap("n", "gi", vim.lsp.buf.implementation,                 kopts('LSP: Implementation'))
      kmap("n", "gr", vim.lsp.buf.references,                     kopts('LSP: References'))
      kmap("n", "ga", vim.lsp.buf.code_action,                    kopts('LSP: Code Action'))
      kmap("n", "gt", vim.lsp.buf.type_definition,                kopts('LSP: Type Definition'))
      kmap("n", "gs", "<cmd>FzfLua lsp_document_symbols<cr>",     kopts('LSP: Go to Symbol'))
      kmap("n", "et", toggle_diagnostics,                         kopts('Diagnostics: Toggle'))

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

local function setup_plugin_venv_selector_python()
  require("venv-selector").setup({
    enable_default_searches = false,
    search = {
      default = {
        command="rg --files --glob '**/python' --follow " .. M.config.python_venv_dir
      }
    },
  })
end

local function setup_plugin_navic()
  require('nvim-navic').setup({
      lsp = {
          auto_attach = true,
          preference = nil,
      },
  })
end

local function setup_plugin_trouble()
  require('trouble').setup({
    win = {
      position = "right",
      size = 100,
    },
  })
end

local function setup_plugin_mason()
  require('mason').setup()
  require('mason-lspconfig').setup()
  require('mason-tool-installer').setup({
    ensure_installed = M.config.mason_ensure_installed
  })
end

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
      -- ['<Tab>'] = { 'select_prev', 'fallback' },
      -- ['<S-Tab>'] = { 'select_next', 'fallback' },
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
  -- vim.keymap.set('n', '<C-S-k>', function() require('hover').switch(); require('hover').open() end, { desc = 'hover.nvim (switch)' })
  -- Use this to enter the documentation in normal mode for movement
  vim.keymap.set('n', 'gK', function() require('hover').enter() end, { desc = 'hover.nvim (enter)' })

end

local function setup_plugin_nvim_treesitter()
  require('nvim-treesitter.configs').setup({
    ensure_installed = M.config.treesitter_ensure_installed,
    highlight = { enable = true },
    indent = { enable = true },
  })
end

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

function M.setup(opts)
  opts = opts or {}
  M.config.python_venv_dir = opts.python_venv_dir or M.config.python_venv_dir
  M.config.mason_ensure_installed = opts.mason_ensure_installed or M.config.mason_ensure_installed
  M.config.treesitter_ensure_installed = opts.treesitter_ensure_installed or M.config.treesitter_ensure_installed
  setup_autocommands_lsp()
  setup_plugin_blink_cmp()
  setup_plugin_hover()
  setup_plugin_mason()
  setup_plugin_navic()
  setup_plugin_nvim_treesitter()
  setup_plugin_trouble()
  setup_plugin_venv_selector_python()

  -- Setup LspConfigs
  setup_lspconfig_rust()

  -- Keymaps
  kmap("n", "tj", function() vim.diagnostic.jump({count = 1, float = true }) end, kopts('Diagnostics: Jump next'))
  kmap("n", "tk", function() vim.diagnostic.jump({count = -1, float = true }) end, kopts('Diagnostics: Jump prev'))
end

return M
