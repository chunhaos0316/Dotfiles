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
  -- Core utilities
  "tpope/vim-sensible",
  
  -- UI Improvements
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('lualine').setup()
    end
  },
  
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({})
    end
  },

  -- Icons (Standalone)
  "nvim-tree/nvim-web-devicons",

  -- Syntax and LSP
  "nvim-treesitter/nvim-treesitter",
  "neovim/nvim-lspconfig",

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

        -- *** 優化 Treesitter (現代高亮) 以符合 Console 風格 ***
        -- 很多現代高亮會給結構體成員顏色，但截圖中沒有
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

-- 5. Basic Neovim settings
vim.opt.number = true             -- Show line numbers
vim.opt.relativenumber = false    -- Show relative line numbers for easier jumping
vim.opt.shiftwidth = 4            -- Size of an indent
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.smartindent = true        -- Insert indents automatically
vim.opt.cursorline = true         -- Highlight the current line
vim.opt.termguicolors = true      -- Enable 24-bit RGB color in the TUI
