# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modular dotfiles repository that uses a numbered directory structure for organized installation order. The repository manages system configuration through symlinks and automated install scripts.

## Core Architecture

### Directory Structure
- **Numbered directories (00_*, 01_*, etc.)**: Components installed in numerical order
  - `00_macos/`: macOS system defaults and settings
  - `01_homebrew/`: Package manager setup and Brewfile
  - `01_hyper/`, `01_ssh/`: Terminal and SSH configuration
  - `02_git/`, `02_gpg/`, `02_oh-my-zsh/`: Version control and shell setup
  - `03_zsh/`: Shell configuration and customization
  - `05_*`: Development tools (gh, java, node)
  - `06_*`, `07_*`: Python environment management (pyenv, pipenv, poetry)
- **work/**: Work-specific configurations as a git submodule
- **functions/**: Shell utility functions
- **Root files**: Core installation and management scripts

### Installation System
- **bootstrap**: Initial setup script that creates symlinks for `*.symlink` files
- **install**: Runs all `install.sh` scripts found in subdirectories
- **bin/dot**: Main management command for updates and maintenance

### Symlink Pattern
Files ending in `.symlink` are automatically linked to `~/.{filename}` (without the .symlink extension) during bootstrap.

## Common Commands

### Initial Setup
```bash
./bootstrap  # Create symlinks for configuration files
./install    # Run all install scripts
```

### Daily Management
```bash
bin/dot                    # Update system (homebrew, run installers)
bin/dot --edit            # Open dotfiles directory for editing
bin/dot --help            # Show help
```

### Work Environment Setup
```bash
bin/setup-work            # Interactive work submodule setup
bin/remove-work           # Remove work submodule
```

### Homebrew Management
```bash
brew bundle install --file="01_homebrew/Brewfile"  # Install packages from Brewfile
brew update && brew upgrade                         # Update packages
```

### Work Environment
The `work/` directory is a git submodule containing work-specific configurations that follow the same numbered directory pattern.

## Key Files and Their Purpose

- **helper.sh**: Utility functions for logging (`info`, `success`, `fail`) and file linking (`link_file`)
- **01_homebrew/Brewfile**: Complete package manifest for system dependencies
- **shipment.yaml**: AsyncAPI specification (appears to be work-related webhook documentation)
- **functions/extract**: Utility function for archive extraction

## Development Workflow

1. **Adding new configurations**: Create appropriately numbered directory with `install.sh` script
2. **Configuration files**: Use `.symlink` extension for files that should be linked to home directory
3. **Installation scripts**: Each component should have its own `install.sh` that can be run independently
4. **Testing changes**: Run `./install` to execute all install scripts after making changes

## Special Considerations

- The system expects `DOTFILES` environment variable to be set to `$HOME/.dotfiles`
- Install scripts are designed to be idempotent and can be run multiple times safely
- The `link_file` function in `helper.sh` provides interactive prompts for handling existing files
- Work-specific configurations are managed separately in the `work/` submodule