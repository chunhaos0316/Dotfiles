-- 1. Map leader keys
-- The leader key is used for custom shortcuts; space is a popular choice.
vim.g.mapleader = " "
vim.g.maplocalleader = " "



-- 2. Setup lazy.nvim path
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"



-- 3. Bootstrap lazy.nvim
-- Automatically clone lazy.nvim if it's not already installed.
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)



-- 4. Initialize lazy.nvim and load plugins
require("lazy").setup({
  -- vim-sensible
  "tpope/vim-sensible",
  
  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('lualine').setup({
        sections = {
          lualine_c = {
            { 'aerial' }
          }
        }
      })
    end,
  },
  
  -- bufferline
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        { "<leader>bn", "<cmd>BufferLineCycleNext<CR>", desc = "Buffer next" },
        { "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", desc = "Buffer previous" },
        { "<leader>bc", "<cmd>Bdelete<CR>", desc = "Close current Buffer" },
        { "<leader>br", "<cmd>BufferLineCloseRight<CR>", desc = "Close all buffers on the right" },
    },
    config = function()
      require("bufferline").setup({})

      for i = 1, 9 do
        vim.keymap.set("n", "<leader>" .. i, function()
          require("bufferline").go_to(i, true)
        end, {
          desc = "Go to Buffer " .. i,
          silent = true,
        })
      end
    end,
  },

  -- nvim-web-devicons
  "nvim-tree/nvim-web-devicons",

  -- nvim-treesitter
  "nvim-treesitter/nvim-treesitter",

  -- nvim-lspconfig
  "neovim/nvim-lspconfig",

  -- neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },

    keys = {
        { "<F8>", ":Neotree toggle<CR>", silent = true },
    },

    config = function()
      require("neo-tree").setup({
        window = {
          position = "right",
          width = 30,
        },

        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
          },
        },
      })
    end,
  },

  -- nvim-autopairs
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
      })
    end,
  },

  -- aerial.nvim
  {
    'stevearc/aerial.nvim',
    opts = {
      layout = {
        max_width = { 40, 0.2 },
        min_width = 20,
        default_direction = "prefer_left",
      },

      show_guides = true,

      filter_kind = {
        "Class",
        "Function",
        "Variable",
        "Constant",
        "Macro",
        "Struct",
        "Enum",
        "Method",
        "Field",
      },

      backends = {
        ["_"] = { "treesitter", "lsp" },
      },
    },

    keys = {
      { "<F7>", "<cmd>AerialToggle!<CR>", desc = "Trigger for Aerial" },

      { "{", "<cmd>AerialPrev<CR>", desc = "Jump to the previous symbol" },
      { "}", "<cmd>AerialNext<CR>", desc = "Jump to the next symbol" },
    },

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
  },

  -- gitsigns
  {
    "lewis6991/gitsigns.nvim",
    keys = {
        { "<F4>", "<cmd>Gitsigns blame_line<CR>" },
    },

    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "+" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },

      current_line_blame = true,
    }
  },

  -- Indent-blankline
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "¦", -- ("|" or "¦")
      },

      whitespace = {
        remove_blankline_trail = false,
      },
    },
  },

  -- Tokyonight Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night", -- storm, night, moon, day
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_colors = function(colors)
        colors.bg = "#000000"
        colors.bg_dark = "#000000"
        colors.bg_float = "#000000"
        colors.border = "#FFFFFF"
        colors.fg = "#DCDCDC"
      end,

      on_highlights = function(hl, c)
        hl.Normal = { fg = "#C0C0C0", bg = "#000000" }
        hl.Comment = { fg = "#87CEFA", italic = false }

        hl.Constant = { fg = "#7B68EE" }
        hl.String = { fg = "#3CB371" }

        hl.Statement = { fg = "#F0E68C" }
        hl.Conditional = { fg = "#F0E68C" }
        hl.Repeat = { fg = "#F0E68C" }
        hl.Operator = { fg = "#DCDCDC" }

        hl.Type = { fg = "#00BFFF" }      -- (int, char)
        hl.PreProc = { fg = "#FFD700" }   -- (#include)

        hl.Special = { fg = "#DDA0DD" }   -- (\n)

        hl.Identifier = { fg = "#00D7FF" }
        hl.Function = { fg = "#00D7FF" }

        hl["@property"] = { fg = "#DCDCDC" }
        hl["@parameter"] = { fg = "#DCDCDC" }

        hl.LineNr = { fg = "#48D1CC", bg = "#000000" }

        hl.Visual = { bg = "#555555" }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
})

-- Keymap
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>', { desc = "Disable highlight" })



-- 5. Basic Neovim settings
vim.opt.number = true             -- Show line numbers
vim.opt.relativenumber = false    -- Show relative line numbers for easier jumping
vim.opt.shiftwidth = 4            -- Size of an indent
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.smartindent = true        -- Insert indents automatically
vim.opt.cursorline = true         -- Highlight the current line
vim.opt.termguicolors = true      -- Enable 24-bit RGB color in the TUI



-- 6. AutoCMD
vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 8
    vim.opt_local.shiftwidth = 8
    vim.opt_local.softtabstop = 0
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    require("lazy").load({ plugins = { "neo-tree.nvim", "aerial.nvim" } })
    vim.cmd("Neotree show")
    vim.cmd("wincmd p")

    vim.cmd("AerialOpen")
  end,
})
