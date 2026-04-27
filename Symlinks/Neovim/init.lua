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
})

-- 5. Basic Neovim settings
vim.opt.number = true             -- Show line numbers
vim.opt.relativenumber = true     -- Show relative line numbers for easier jumping
vim.opt.shiftwidth = 4            -- Size of an indent
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.smartindent = true        -- Insert indents automatically
vim.opt.cursorline = true         -- Highlight the current line
vim.opt.termguicolors = true      -- Enable 24-bit RGB color in the TUI
