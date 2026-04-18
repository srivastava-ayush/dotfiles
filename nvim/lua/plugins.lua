-- ============================================================
--  plugins.lua — Lazy.nvim plugin spec
--  Place this file at: ~/.config/nvim/lua/plugins.lua
--  (or split into ~/.config/nvim/lua/plugins/*.lua)
-- ============================================================

return {

  -- ──────────────────────────────────────────────────────────
  -- 1. PLUGIN MANAGER UTILS
  -- ──────────────────────────────────────────────────────────

  -- Useful lua functions used by many plugins
  { "nvim-lua/plenary.nvim", lazy = true },

  -- Icon support (requires a Nerd Font)
  { "nvim-tree/nvim-web-devicons", lazy = true },


  -- ──────────────────────────────────────────────────────────
  -- 2. UI / COLORSCHEME
  -- ──────────────────────────────────────────────────────────

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- load before everything else
    config = function()
      require("catppuccin").setup({ flavour = "mocha" })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "catppuccin",
        globalstatus = true,
      },
    },
  },

  -- Bufferline (tab bar)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Dashboard / start screen
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = { theme = "hyper" },
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPost",
    opts = {},
  },

  -- Show hex colours inline
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {},
  },

  -- Notification system
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      vim.notify = require("notify")
    end,
  },

  -- Better vim.ui.input / vim.ui.select
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },


  -- ──────────────────────────────────────────────────────────
  -- 3. FILE TREE
  -- ──────────────────────────────────────────────────────────

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = { { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "File Explorer" } },
    opts = {
      filters = { dotfiles = false },
      renderer = { group_empty = true },
    },
  },


  -- ──────────────────────────────────────────────────────────
  -- 4. FUZZY FINDER
  -- ──────────────────────────────────────────────────────────

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>",  desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",   desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>",     desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>",   desc = "Help Tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>",    desc = "Recent Files" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = { fzf = {} },
      })
      telescope.load_extension("fzf")
    end,
  },


  -- ──────────────────────────────────────────────────────────
  -- 5. TREESITTER (syntax / highlighting)
  -- ──────────────────────────────────────────────────────────

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",       -- auto-close HTML tags
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc",
          "python", "javascript", "typescript", "tsx",
          "html", "css", "json", "yaml", "toml",
          "bash", "markdown", "markdown_inline",
          "rust", "go", "c", "cpp",
        },
        highlight = { enable = true },
        indent = { enable = true },
        autotag = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      })
    end,
  },


  -- ──────────────────────────────────────────────────────────
  -- 6. LSP
  -- ──────────────────────────────────────────────────────────

  -- Mason: install/manage LSP servers, linters, formatters
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {},
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls", "pyright", "ts_ls",
        "html", "cssls", "jsonls",
        "rust_analyzer", "gopls",
      },
      automatic_installation = true,
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "folke/neodev.nvim", opts = {} }, -- Neovim API completion
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Common on_attach for keymaps
      local on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end
        map("gd",         vim.lsp.buf.definition,       "Go to Definition")
        map("gD",         vim.lsp.buf.declaration,      "Go to Declaration")
        map("gr",         vim.lsp.buf.references,       "References")
        map("gi",         vim.lsp.buf.implementation,   "Go to Implementation")
        map("K",          vim.lsp.buf.hover,            "Hover Docs")
        map("<leader>rn", vim.lsp.buf.rename,           "Rename")
        map("<leader>ca", vim.lsp.buf.code_action,      "Code Action")
        map("<leader>d",  vim.diagnostic.open_float,    "Line Diagnostics")
        map("[d",         vim.diagnostic.goto_prev,     "Prev Diagnostic")
        map("]d",         vim.diagnostic.goto_next,     "Next Diagnostic")
      end

      -- Auto-setup all installed servers with shared defaults
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
          })
        end,
        -- Override specific servers here:
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = { Lua = { diagnostics = { globals = { "vim" } } } },
          })
        end,
      })
    end,
  },


  -- ──────────────────────────────────────────────────────────
  -- 7. COMPLETION
  -- ──────────────────────────────────────────────────────────

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },


  -- ──────────────────────────────────────────────────────────
  -- 8. FORMATTING & LINTING
  -- ──────────────────────────────────────────────────────────

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true }) end, desc = "Format Buffer" },
    },
    opts = {
      formatters_by_ft = {
        lua        = { "stylua" },
        python     = { "black", "isort" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json       = { "prettier" },
        yaml       = { "prettier" },
        markdown   = { "prettier" },
        rust       = { "rustfmt" },
        go         = { "gofmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python     = { "flake8" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function() lint.try_lint() end,
      })
    end,
  },


  -- ──────────────────────────────────────────────────────────
  -- 9. GIT
  -- ──────────────────────────────────────────────────────────

  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs = {
        add    = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Git: " .. desc })
        end
        map("]h", gs.next_hunk,        "Next Hunk")
        map("[h", gs.prev_hunk,        "Prev Hunk")
        map("<leader>hs", gs.stage_hunk,   "Stage Hunk")
        map("<leader>hr", gs.reset_hunk,   "Reset Hunk")
        map("<leader>hp", gs.preview_hunk, "Preview Hunk")
        map("<leader>hb", gs.blame_line,   "Blame Line")
      end,
    },
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    keys = { { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" } },
  },


  -- ──────────────────────────────────────────────────────────
  -- 10. EDITING HELPERS
  -- ──────────────────────────────────────────────────────────

  -- Auto pairs ( [ { ' "
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { check_ts = true },
  },

  -- Surround: ys, ds, cs
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Comment: gcc / gbc
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Multiple cursors / fast motions
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s",     function() require("flash").jump()              end, desc = "Flash Jump" },
      { "S",     function() require("flash").treesitter()        end, desc = "Flash Treesitter" },
      { "r",     function() require("flash").remote()            end, desc = "Flash Remote", mode = "o" },
      { "R",     function() require("flash").treesitter_search() end, desc = "Treesitter Search", mode = { "o", "x" } },
    },
  },

  -- Highlight word under cursor
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    config = function()
      require("illuminate").configure({ delay = 200 })
    end,
  },


  -- ──────────────────────────────────────────────────────────
  -- 11. TERMINAL
  -- ──────────────────────────────────────────────────────────

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = { { "<C-\\>", desc = "Toggle Terminal" } },
    opts = {
      open_mapping = [[<C-\>]],
      direction = "float",
      float_opts = { border = "curved" },
    },
  },


  -- ──────────────────────────────────────────────────────────
  -- 12. WHICH-KEY (keybinding hints)
  -- ──────────────────────────────────────────────────────────

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({})
      wk.add({
        { "<leader>f",  group = "Find (Telescope)" },
        { "<leader>h",  group = "Git Hunks" },
        { "<leader>c",  group = "Code" },
        { "<leader>g",  group = "Git" },
      })
    end,
  },


  -- ──────────────────────────────────────────────────────────
  -- 13. TROUBLE (diagnostics panel)
  -- ──────────────────────────────────────────────────────────

  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",                        desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",           desc = "Buffer Diagnostics" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<CR>",                desc = "Symbols" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "LSP Definitions" },
    },
    opts = {},
  },


  -- ──────────────────────────────────────────────────────────
  -- 14. MISC QUALITY-OF-LIFE
  -- ──────────────────────────────────────────────────────────

  -- Smooth scrolling
  { "karb94/neoscroll.nvim", event = "VeryLazy", opts = {} },

  -- Better quickfix list
  { "kevinhwang91/nvim-bqf", ft = "qf" },

  -- Persistent undo tree visualiser
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Undo Tree" } },
  },

  -- Markdown preview (opens browser)
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },

} -- end return