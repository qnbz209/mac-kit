# dotfiles Project Instructions

This repository is dedicated to managing and automating the setup of a macOS environment.

## Project Structure
- `setup.sh`: The primary entry point for setting up the environment. It handles Homebrew installation, package management, and configuration symlinking.
- `configs/`: Contains configuration files for various tools (e.g., Neovim, tmux).

## Development Guidelines
- **Single Script:** Maintain a monolithic `setup.sh` for simplicity, as per user preference.
- **Homebrew First:** Use Homebrew for system tools and applications.
- **mise for Languages:** Use `mise` for managing programming language runtimes (Node.js, Python, Go, etc.) to keep the system clean and version-controlled.
- **Symlinking:** Configurations in the `configs/` directory should be symlinked to the appropriate home directory locations by `setup.sh`.
- **Idempotency:** The `setup.sh` script should be safe to run multiple times without causing errors or duplicate configurations.
