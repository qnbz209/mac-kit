# mac-kit

Automated macOS setup and configuration management.

## Usage

To set up your Mac, run the following command in your terminal:

```bash
chmod +x setup.sh
./setup.sh
```

## Included Tools
- Homebrew (Packages managed declaratively via `Brewfile`)
- iTerm2
- Discord
- Google Gemini & Antigravity (App & CLI)
- Neovim (with Zenbones light theme & LSP)
- tmux (configured with prefix Ctrl-a)
- fzf, ripgrep, fd
- mise (language manager)

## Keybindings & Usage

### 🚀 Seamless Navigation (Neovim & tmux)
Navigate between Neovim splits and tmux panes using the same keys:
- `Ctrl + h` : Move Left
- `Ctrl + j` : Move Down
- `Ctrl + k` : Move Up
- `Ctrl + l` : Move Right

### 📝 Neovim (Leader key is `Space`)
- `<Space> + e` : Toggle File Explorer (nvim-tree)
- `<Space> + f` : Search files by name (Telescope)
- `<Space> + g` : Live grep search inside files (Telescope)

#### Language Support (LSP)
- `gd` : Go to definition
- `gr` : Go to references (Go to Reference)
- `<Space> + k` : Hover documentation
- `<Space> + rn` : Rename symbol
- `<Space> + ca` : Code actions (Quick fix)
- `Ctrl + n/p`  : Navigate completion menu
- `Ctrl + y`    : Confirm completion

### 🖥️ tmux
- **Prefix**: `Ctrl + a` (Changed from default `Ctrl + b`)
- `Prefix + %` : Split window vertically
- `Prefix + "` : Split window horizontally
- `Prefix + c` : New window
- `Prefix + 1-9` : Switch windows
- Mouse support is enabled for resizing and selecting panes.
