#!/usr/bin/env bash

# ==============================================================================
# Dotfiles Setup Script
# Supports: macOS (Darwin) and Linux (Debian/Ubuntu based)
# ==============================================================================

# Define color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# ---------------------------------------------------------
# Utility Functions
# ---------------------------------------------------------

is_installed() {
    command -v "$1" &> /dev/null
}

# ---------------------------------------------------------
# 1. Package Installation
# ---------------------------------------------------------

install_macos_packages() {
    echo -e "${BLUE}==> [macOS] Installing packages via Homebrew...${NC}"
    if ! is_installed brew; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    local packages=(vim neovim git zsh wget tree tmux gcc global)
    for pkg in "${packages[@]}"; do
        local cmd=$pkg
        [[ "$pkg" == "neovim" ]] && cmd="nvim"

        if is_installed "$cmd"; then
            echo -e "${GREEN}  - $cmd already installed, skipping.${NC}"
        else
            brew install "$pkg"
        fi
    done
}

install_linux_packages() {
    echo -e "${BLUE}==> [Linux] Installing packages via APT...${NC}"
    sudo apt-get update -y
    local packages=(vim neovim git zsh wget tree build-essential tmux global)
    for pkg in "${packages[@]}"; do
        local cmd=$pkg
        [[ "$pkg" == "neovim" ]] && cmd="nvim"

        if is_installed "$cmd"; then
            echo -e "${GREEN}  - $cmd already installed, skipping.${NC}"
        else
            sudo apt-get install -y "$pkg"
        fi
    done
}

# ---------------------------------------------------------
# 2. Nerd Fonts Installation
# ---------------------------------------------------------

setup_nerd_fonts() {
    echo -e "${BLUE}==> Checking for Nerd Fonts...${NC}"
    local font_installed=false
    if [[ "$OSTYPE" == "darwin"* ]]; then
        [[ $(ls ~/Library/Fonts/MesloLGS* 2>/dev/null) ]] && font_installed=true
    else
        [[ $(ls ~/.local/share/fonts/MesloLGS* 2>/dev/null) ]] && font_installed=true
    fi

    if [ "$font_installed" = true ]; then
        echo -e "${GREEN}  - MesloLGS NF is already installed.${NC}"
    else
        echo -e "${YELLOW}  - Downloading MesloLGS NF...${NC}"
        local temp_dir=$(mktemp -d)
        local urls=(
            "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
            "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
            "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
            "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
        )
        for url in "${urls[@]}"; do wget -q --show-progress -P "$temp_dir" "$url"; done
        if [[ "$OSTYPE" == "darwin"* ]]; then
            cp "$temp_dir"/*.ttf ~/Library/Fonts/
        else
            mkdir -p ~/.local/share/fonts && cp "$temp_dir"/*.ttf ~/.local/share/fonts/ && fc-cache -fv
        fi
        rm -rf "$temp_dir"
    fi
}

# ---------------------------------------------------------
# 3. Zsh & Powerlevel10k Setup
# ---------------------------------------------------------

setup_zsh_advanced() {
    echo -e "${BLUE}==> Configuring Zsh...${NC}"
    [[ "$SHELL" != "$(which zsh)" ]] && chsh -s "$(which zsh)"
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    [[ ! -d "$p10k_dir" ]] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
}

# ---------------------------------------------------------
# 4. Symbolic Links (Including c.vim)
# ---------------------------------------------------------

setup_symlinks() {
    echo -e "${BLUE}==> Creating symbolic links...${NC}"
    SYMLINKS_BASE_DIR="$DOTFILES_DIR/Symlinks"
    
    # Format: "Source_Relative_Path:Target_Home_Path"
    local files_to_link=(
        "Zsh/zshrc:$HOME/.zshrc"
        "Zsh/p10k.zsh:$HOME/.p10k.zsh"
        "Vim/vimrc:$HOME/.vimrc"
        # "Vim/c.vim:$HOME/.vim/after/ftplugin/c.vim" # Link c.vim for C filetype plugins
        "Git/gitconfig:$HOME/.gitconfig"
        "Tmux/tmux.conf:$HOME/.tmux.conf"
        # "SnipMate:$HOME/.vim/snippets"
        "Neovim/init.lua:$HOME/.config/nvim/init.lua"
    )

    for item in "${files_to_link[@]}"; do
        relative_src="${item%%:*}"
        dst_path="${item#*:}"
        full_src="$SYMLINKS_BASE_DIR/$relative_src"
        
        if [ -e "$full_src" ]; then
            if [ -L "$dst_path" ] && [ "$(readlink "$dst_path")" == "$full_src" ]; then
                echo -e "${GREEN}  - Link $relative_src already correct.${NC}"
            else
                echo -e "  - Linking ${YELLOW}$relative_src${NC} to ${YELLOW}$dst_path${NC}"
                mkdir -p "$(dirname "$dst_path")"
                ln -sfn "$full_src" "$dst_path"
            fi
        fi
    done
}

# ---------------------------------------------------------
# 5. Vim Plugins
# ---------------------------------------------------------

setup_vim_plugins() {
    # Vundle
    echo -e "${BLUE}==> Setting up Vim plugins...${NC}"
    local vundle_dir="$HOME/.vim/bundle/Vundle.vim"
    [[ ! -d "$vundle_dir" ]] && git clone https://github.com/VundleVim/Vundle.vim.git "$vundle_dir"
    vim +PluginInstall +qall
}

setup_neovim_plugins() {
    # Neovim lazy.nvim
    echo -e "${BLUE}==> Setting up Neovim plugins (lazy.nvim)...${NC}"
    local lazy_path="$HOME/.local/share/nvim/site/pack/lazy/start/lazy.nvim"
    if [ ! -d "$lazy_path" ]; then
        echo -e "${YELLOW}  - Installing lazy.nvim...${NC}"
        git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$lazy_path"
    else
        echo -e "${GREEN}  - lazy.nvim already installed.${NC}"
    fi

    if [ -f "$HOME/.config/nvim/init.lua" ]; then
        echo -e "${YELLOW}  - Syncing Neovim plugins...${NC}"
        nvim --headless "+Lazy! sync" +qa
    fi
}

# ---------------------------------------------------------
# Main Execution Flow
# ---------------------------------------------------------

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS_TYPE="$(uname -s)"

case "${OS_TYPE}" in
    Darwin*) install_macos_packages ;;
    Linux*)  install_linux_packages ;;
    *) exit 1 ;;
esac

setup_nerd_fonts
setup_zsh_advanced
setup_symlinks
# setup_vim_plugins
setup_neovim_plugins

echo -e "${GREEN}All done! Please restart your terminal and set font to MesloLGS NF.${NC}"
