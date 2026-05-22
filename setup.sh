#!/bin/bash

# mac-kit setup script
# This script installs Homebrew, packages, and sets up configuration symlinks.

set -e

# Get the absolute path of the mac-kit directory
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting mac-kit setup..."

# 1. Check for Homebrew and install if not present
if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for the current session (for Apple Silicon Macs)
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed. Updating..."
    brew update
fi

# 2. Install Packages
echo "Installing Homebrew packages from Brewfile..."
if [ -f "$REPO_ROOT/Brewfile" ]; then
    brew bundle --file="$REPO_ROOT/Brewfile"
else
    echo "Error: Brewfile not found at $REPO_ROOT/Brewfile"
    exit 1
fi

# 3. Shell Setup (Oh-My-Zsh & Powerlevel10k)
echo "Setting up Zsh, Oh-My-Zsh, and Powerlevel10k..."

# Install Oh-My-Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k theme
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Install plugins
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# 4. mise setup
echo "Setting up mise (programming language manager)..."
if command -v mise >/dev/null 2>&1; then
    # mise install will be handled after symlinking the config
    echo "mise installed. Language runtimes will be installed after config symlinking."
fi

# 5. Setup Symbolic Links
echo "Setting up configuration symlinks..."

# Ensure ~/.config directory exists
mkdir -p "$HOME/.config"

# REPO_ROOT is defined at the top of the script

# Zsh config
for f in .zshrc .p10k.zsh; do
    if [ -f "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
        echo "Backing up existing $f..."
        mv "$HOME/$f" "$HOME/$f.bak"
    fi
    echo "Linking $f..."
    ln -sf "$REPO_ROOT/configs/zsh/$f" "$HOME/$f"
done

# Neovim config
if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
    echo "Backing up existing nvim config..."
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
fi
echo "Linking Neovim config..."
ln -sf "$REPO_ROOT/configs/nvim" "$HOME/.config/nvim"

# Tmux config
if [ -f "$HOME/.tmux.conf" ] && [ ! -L "$HOME/.tmux.conf" ]; then
    echo "Backing up existing tmux config..."
    mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
fi
echo "Linking tmux config..."
ln -sf "$REPO_ROOT/configs/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Mise config
mkdir -p "$HOME/.config/mise"
if [ -f "$HOME/.config/mise/config.toml" ] && [ ! -L "$HOME/.config/mise/config.toml" ]; then
    echo "Backing up existing mise config..."
    mv "$HOME/.config/mise/config.toml" "$HOME/.config/mise/config.toml.bak"
fi
echo "Linking mise config..."
ln -sf "$REPO_ROOT/configs/mise/config.toml" "$HOME/.config/mise/config.toml"

# Run mise install to install languages defined in the config
if command -v mise >/dev/null 2>&1; then
    echo "Installing language runtimes via mise..."
    mise install
    echo "Note: Make sure to add 'eval \"\$(mise activate zsh)\"' to your .zshrc"
fi

# 6. Cleanup
echo "Cleaning up..."
brew cleanup

echo "Setup complete! Please restart your terminal or source your configs to see changes."
