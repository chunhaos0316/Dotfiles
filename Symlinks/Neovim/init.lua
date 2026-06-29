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

  -- telescope.nvim
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },

    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>",  desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",   desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>",     desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>",   desc = "Help tags" },
    },

    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
            },
          },

          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "%.o",
            "%.a",
            "%.out",
          },
        },

        pickers = {
          find_files = {
            hidden = true,
          },
          live_grep = {
            additional_args = function()
              return { "--hidden" }
            end,
          },
        },
      })

      -- Load fzf native extension if available
      pcall(telescope.load_extension, "fzf")
    end,
  },

  -- cscope_maps.nvim
  {
    "dhananjaylatkar/cscope_maps.nvim",
    event = "BufReadPost",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },

    config = function()
      require("cscope_maps").setup({
        disable_maps = false,
        skip_input_conversion = true,
        prefix = "<leader>c",

        cscope = {
          db_file = "./GTAGS",
          exec = "gtags-cscope",
          picker = "telescope",
          auto_refresh = true,
        }
      })
  end,
  },

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

    config = function()
      local gitsigns = require("gitsigns")

      gitsigns.setup({
        signs = {
          add = { text = "+" },
          change = { text = "|" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },

        current_line_blame = true,

        on_attach = function(bufnr)
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end, "Next hunk")

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end, "Prev hunk")

          map('n', '<F6>', gitsigns.blame)
          map('n', '<leader>hd', gitsigns.diffthis)
          map('n', '<leader>hp', gitsigns.preview_hunk)
          map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
        end,
      })
    end,
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
vim.opt.ignorecase = true         -- Case insensitive when searching
vim.opt.smartcase = true          -- Case sensitive when there is upper case in the target strings



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
  once = true,
  callback = function()
    require("lazy").load({ plugins = { "neo-tree.nvim", "aerial.nvim" } })
    vim.cmd("Neotree show")
    vim.cmd("wincmd p")

    vim.cmd("AerialOpen")
  end,
})

vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    -- Get all current windows on the screen
    local invalid_win = {}
    local wins = vim.api.nvim_list_wins()
    local c_file_count = 0

    for _, win in ipairs(wins) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })

      -- Check if the window is Neo-tree or Aerial
      if ft == "neo-tree" or ft == "aerial" then
        table.insert(invalid_win, win)
      -- Check if it's a regular file (excluding special buffers and empty buffers)
      elseif ft ~= "" and vim.api.nvim_get_option_value("buftype", { buf = buf }) == "" then
        c_file_count = c_file_count + 1
      end
    end

    -- If only 1 regular file is left (the one you are currently closing)
    -- and there are remaining Neo-tree or Aerial windows, close them as well
    if c_file_count <= 1 then
      for _, win in ipairs(invalid_win) do
        -- Safely close the remaining plugin windows
        pcall(vim.api.nvim_win_close, win, true)
      end
    end
  end,
})
