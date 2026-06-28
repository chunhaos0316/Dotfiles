# Dotfiles

This dotfiles repo provides a ready-to-use development environment covering:

- `zsh` + `oh-my-zsh` + `powerlevel10k`
- `vim`
- `neovim`
- `tmux`
- `git`
- `cscope` / `gtags`

The main entry point is [`setup.sh`](./setup.sh), and the Neovim configuration lives in [`Symlinks/Neovim/init.lua`](./Symlinks/Neovim/init.lua).

## Installation

Run this from the repo root:

```bash
bash setup.sh
```

`setup.sh` automatically does the following:

1. Installs required packages
   - macOS uses `Homebrew`
   - Linux uses `apt`
2. Installs the `MesloLGS NF` font
3. Installs and configures `oh-my-zsh` and `powerlevel10k`
4. Creates configuration symlinks
5. Installs Vim plugins
6. Installs Neovim plugins and runs `:Lazy sync`

After installation, restart your terminal and make sure the font is set to `MesloLGS NF`.

## Symlink Map

`setup.sh` links files from `Symlinks/` into your home directory:

- `Symlinks/Zsh/zshrc` -> `~/.zshrc`
- `Symlinks/Zsh/p10k.zsh` -> `~/.p10k.zsh`
- `Symlinks/Vim/vimrc` -> `~/.vimrc`
- `Symlinks/Vim/c.vim` -> `~/.vim/after/ftplugin/c.vim`
- `Symlinks/Git/gitconfig` -> `~/.gitconfig`
- `Symlinks/Tmux/tmux.conf` -> `~/.tmux.conf`
- `Symlinks/SnipMate` -> `~/.vim/snippets`
- `Symlinks/Neovim/init.lua` -> `~/.config/nvim/init.lua`

## Neovim Overview

`init.lua` uses [`lazy.nvim`](https://github.com/folke/lazy.nvim) to manage plugins.

Leader key:

- `vim.g.mapleader = " "`
- `vim.g.maplocalleader = " "`

`Esc` clears search highlighting:

- `Esc` -> `:nohlsearch`

## Plugins and Keybindings

### `vim-sensible`

Provides a more sensible set of Vim defaults so Neovim behaves more consistently.

- No custom keybindings

### `lualine.nvim`

Status line at the bottom of the editor showing mode, file information, and other state.

This configuration changes `lualine_c` to show `aerial` information.

- No custom keybindings

### `bufferline.nvim`

Shows a buffer tabline for switching between open files.

Keybindings:

- `<leader>bn`: go to the next buffer
- `<leader>bp`: go to the previous buffer
- `<leader>bc`: close the current buffer
- `<leader>br`: close all buffers to the right
- `<leader>1` to `<leader>9`: jump directly to buffer 1 through 9

### `nvim-web-devicons`

Provides file-type icons for UIs such as `lualine`, `bufferline`, and `neo-tree`.

- No custom keybindings

### `nvim-treesitter`

Provides more accurate syntax parsing and highlighting, and is a dependency for `aerial` and some LSP-related features.

- No custom keybindings

### `nvim-lspconfig`

Entry point for LSP configuration. This setup currently only loads the plugin and does not define extra servers or keybindings.

- No custom keybindings

### `cscope_maps.nvim`

Used with `gtags-cscope` and `telescope` for code navigation and symbol search.

Current configuration:

- `prefix = "<leader>c"`
- `db_file = "./GTAGS"`
- `exec = "gtags-cscope"`
- `picker = "telescope"`
- `auto_refresh = true`

Usage:

- Generate `GTAGS` in the project directory first
- In Neovim, use the `<leader>c`-prefixed cscope mappings

Notes:

- The actual subcommands come from the default mappings provided by `cscope_maps.nvim`
- `init.lua` does not override those sub-mappings, so use the `<leader>c` prefix and the plugin defaults

### `neo-tree.nvim`

File tree browser. This configuration places it on the right with a width of 30.

Keybindings:

- `<F8>`: toggle `neo-tree`

Configuration details:

- Shows dotfiles
- Right-side window

### `nvim-autopairs`

Automatically inserts matching pairs such as brackets and quotes when entering Insert mode.

- No custom keybindings

### `aerial.nvim`

Displays an outline of the current file's symbols such as classes, functions, structs, and variables.

Keybindings:

- `<F7>`: toggle `Aerial`
- `{`: jump to the previous symbol
- `}`: jump to the next symbol

Configuration details:

- Prefers `treesitter` and `lsp`
- The outline opens on the left
- Filters to common symbol kinds such as `Class`, `Function`, `Struct`, and `Enum`

### `gitsigns.nvim`

Shows Git diff signs directly inside the editor.

Enabled signs:

- `+`: added or changed
- `_`: deleted
- `‾`: top delete
- `~`: changed with deletions
- `current_line_blame = true`: show blame info for the current line

- No custom keybindings

### `indent-blankline.nvim`

Shows indentation guides to make code structure easier to read.

Configuration:

- Uses `¦` as the indent character
- Keeps trailing blankline guides enabled

- No custom keybindings

### `tokyonight.nvim`

Theme and color configuration.

Current settings:

- `style = "night"`
- `transparent = true`
- Transparent sidebars and floating windows
- Custom black background and selected syntax colors

- No custom keybindings

## FileType / AutoCmd Behavior

### `make`

When opening `make` filetypes:

- `expandtab = false`
- `tabstop = 8`
- `shiftwidth = 8`
- `softtabstop = 0`

### `c` / `cpp`

When opening a C or C++ file for the first time, Neovim will automatically:

- Lazy-load `neo-tree.nvim` and `aerial.nvim`
- Open `neo-tree`
- Open `Aerial`

### `QuitPre`

When leaving the last regular file, any remaining `neo-tree` or `aerial` windows are closed automatically so no orphan plugin windows remain.

