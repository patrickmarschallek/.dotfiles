# .dotfiles

A modular, organized dotfiles repository for macOS development environment setup and configuration management.

## 🚀 Quick Start

### **🌐 Remote Installation (Recommended for Fresh Machines)**
```bash
# One-command installation with automatic restart handling
curl -fsSL https://raw.githubusercontent.com/patrickmarschallek/.dotfiles/main/install-remote.sh | bash
```
- ✅ **Handles macOS updates** and restart cycles automatically
- ✅ **Resumes installation** after reboots until complete
- ✅ **Sets up daily update checking** automatically
- 📖 **Full guide**: [REMOTE_INSTALL.md](REMOTE_INSTALL.md)

### **📂 Manual Installation**
```bash
# Clone the repository
git clone https://github.com/patrickmarschallek/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Bootstrap symlinks
./bootstrap

# Install everything
./install

# Or use the management command
bin/dot
```

## 📁 Project Structure

### Core Components (Installation Order)

```
00_macos/          # macOS system defaults and settings
01_homebrew/       # Package manager and applications
01_hyper/          # Terminal emulator configuration
01_ssh/            # SSH configuration
02_git/            # Git configuration and aliases
02_gpg/            # GPG configuration
02_oh-my-zsh/      # Zsh framework setup
03_zsh/            # Shell configuration and customization
04_colima/         # Container runtime with Docker compatibility
05_gh/             # GitHub CLI
05_java/           # Java development environment (multiple versions)
05_node/           # Node.js development setup
06_pyenv/          # Python version management
07_pipenv/         # Python package management
07_poetry/         # Python dependency management
work/              # Work-specific configurations (git submodule)
```

### Supporting Files

```
bin/dot            # Main management command
bootstrap          # Symlink creation script
install            # Run all install scripts
helper.sh          # Utility functions for scripts
functions/         # Shell utility functions
CLAUDE.md          # AI assistant guidance
PATTERN_ANALYSIS.md # Project structure analysis
```

## 🛠️ Key Features

### **Automated Installation**
- **Numbered directories** ensure proper installation order
- **Modular design** allows installing specific components
- **Idempotent scripts** can be run multiple times safely

### **Application Management**
- **Homebrew integration** with comprehensive Brewfile
- **Installation checking** prevents duplicate downloads
- **Interactive prompts** for missing applications

### **Development Environment**
- **Java multi-version support** (11, 17, 21) via Eclipse Temurin
- **Python environment management** via pyenv, pipenv, poetry
- **Node.js setup** with version management
- **Container development** with Colima + Docker

### **Shell Enhancement**
- **Zsh configuration** with oh-my-zsh
- **Custom aliases and functions** for productivity
- **PATH management** across all tools
- **Work/personal separation** via git submodule

## 📋 Installation Components

### **System & Core Tools**
- **macOS defaults** and system settings
- **Homebrew** with 40+ packages and applications
- **Terminal setup** (Hyper, fonts, themes)

### **Development Applications**
- **IDEs**: IntelliJ IDEA, DataGrip, Visual Studio Code
- **Tools**: Postman, Obsidian
- **Container runtime**: Colima with Docker compatibility

### **Development Languages**
- **Java**: Eclipse Temurin 11, 17, 21 with jenv management
- **Python**: pyenv + pipenv + poetry for complete environment management
- **Node.js**: nvm integration for version management

### **Version Control**
- **Git configuration** with aliases and shortcuts
- **GPG setup** for commit signing
- **GitHub CLI** integration

## 🎯 Usage Examples

### **Daily Management**
```bash
bin/dot                    # Update system and run all installers
bin/dot --edit            # Open dotfiles for editing
bin/dot --help            # Show help
dotfiles-registry summary # Overview of all available tools
```

### **Application Management**
```bash
brewcheck                 # Check which apps are installed
brew-install-missing      # Interactive install of missing apps
brewupdate               # Update all packages
```

### **Container Development**
```bash
clm-start                # Start Colima with optimal settings
clm-status               # Show comprehensive status
clm-socket check         # Verify Docker socket configuration
clm-upgrade upgrade      # Update Colima and recreate VM
```

### **Java Development**
```bash
jenv versions            # List available Java versions
jenv global 17.0         # Set global Java version
jenv local 11.0          # Set project-specific version
```

## 🔧 Advanced Features

### **Colima Container Runtime**
- **Docker compatibility** without Docker Desktop overhead
- **Multiple profiles** for different development needs
- **Testcontainers integration** with proper environment variables
- **Socket management** for tool compatibility
- **Upgrade and maintenance** helpers

### **Shell Integration**
- **Automatic environment setup** for all development tools
- **Custom aliases** for frequently used commands
- **PATH management** ensures correct tool priorities
- **Work-specific overrides** via git submodule

### **Work Environment Separation**
- **Private git repository** (`work/`) for company-specific configurations
- **Security-first approach** - work configs never touch public repository
- **Independent versioning** with separate corporate GitHub repository
- **Automatic integration** during installation and daily workflows

## 📖 Component Details

### **Homebrew (01_homebrew/)**
- **Comprehensive Brewfile** with development tools
- **Installation verification** prevents duplicate downloads
- **Package management** helpers and aliases

### **Java Environment (05_java/)**
- **Multiple JDK versions** (11, 17, 21) via Eclipse Temurin
- **jenv integration** for seamless version switching
- **Automatic registration** of all installed versions

### **Container Development (04_colima/)**
- **Colima runtime** with Docker API compatibility
- **Helper scripts** for common operations
- **Testcontainers support** with proper environment variables
- **Upgrade and maintenance** automation

### **Python Development (06_pyenv/ + 07_pipenv/ + 07_poetry/)**
- **pyenv** for Python version management
- **pipenv** for virtual environments and dependency management
- **poetry** for modern Python project management

## 🤝 Contributing

1. **Follow the numbered directory pattern** for installation order
2. **Include install.sh** in each component directory
3. **Use helper.sh functions** (`info`, `success`, `fail`) for consistent output
4. **Add *.zsh files** for shell integration
5. **Test installation** on fresh system before committing

## 📚 Documentation

- **REMOTE_INSTALL.md** - Complete guide for one-command installation on fresh machines
- **TOOLS_REGISTRY.md** - Comprehensive registry of all available tools, aliases, and functions
- **QUICK_REFERENCE.md** - Daily command cheat sheet for common operations
- **WORK_SUBMODULE_GUIDE.md** - Security guide for managing work-specific configurations
- **CLAUDE.md** - Guidance for AI assistants working with this repository
- **PATTERN_ANALYSIS.md** - Detailed analysis of project structure and patterns
- **Individual component READMEs** - Component-specific documentation

### **🔍 Tool Discovery**
```bash
dotfiles-registry          # Interactive tool discovery
dotfiles-registry summary  # Quick overview of all tools
dotfiles-registry search X # Find tools containing X
```

## ✅ System Requirements

- **macOS** (tested on recent versions)
- **Bash/Zsh shell**
- **Internet connection** for downloading packages
- **Administrator privileges** for some installations

---

*This dotfiles repository provides a complete, modular development environment setup with strong organizational patterns and extensive automation.*
