# .dotfiles

A modular, organized dotfiles repository for macOS development environment setup and configuration management.

## 🚀 Quick Start

### **🌐 Remote Installation (Recommended)**
```bash
# One-command installation with automatic restart handling
curl -fsSL https://raw.githubusercontent.com/patrickmarschallek/.dotfiles/main/install-remote.sh | bash
```
- ✅ **Handles macOS updates** and restart cycles automatically
- ✅ **Resumes installation** after reboots until complete
- ✅ **Sets up daily update checking** automatically

### **📂 Manual Installation**
```bash
# Clone and install
git clone https://github.com/patrickmarschallek/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap && ./install
```

## 📁 Architecture & Structure

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
08_ai_tools/       # AI development tools (Ollama, WebUI)
work/              # Work-specific configurations (git submodule)
```

### Key Files
```
bin/dot            # Main management command
bootstrap          # Symlink creation script
install            # Run all install scripts
helper.sh          # Utility functions for scripts
functions/         # Shell utility functions
```

### Directory Patterns
- **Numbered prefixes**: `00_`, `01_`, `02_`, etc. for installation order
- **Descriptive names**: Clear indication of purpose
- **Grouping logic**: Similar tools grouped in same number range
- **Symlink files**: `*.symlink` files automatically linked to `~/.{filename}`

## 🛠️ Key Features

### **Automated Installation System**
- **Modular components** with individual `install.sh` scripts
- **Idempotent execution** - can be run multiple times safely
- **Error handling** with comprehensive logging
- **Resume capability** for interrupted installations

### **Development Environment**
- **Multi-language support**: Java (8,11,17,21), Python, Node.js
- **Container development**: Colima + Docker without Docker Desktop
- **AI tools**: Ollama local LLMs + Open WebUI interface
- **Package management**: Homebrew with 40+ packages

### **Work/Personal Separation**
- **Git submodule** for work-specific configurations
- **Security-first approach** - corporate configs stay private
- **Independent versioning** with separate repositories

## 🎯 Tool Registry & Discovery

### **Interactive Discovery**
```bash
dotfiles-registry          # Interactive tool discovery
dotfiles-registry summary  # Quick overview of all tools
dotfiles-registry search X # Find tools containing X
```

### **Key Tool Categories**

#### **🍺 Package Management**
```bash
brewcheck                 # Check installation status
brew-install-missing      # Interactive install missing apps
brewupdate               # Update all packages
brewclean                # Clean unused packages
```

#### **🐳 Container Development**
```bash
clm-start                # Start Colima with optimal settings
clm-status               # Comprehensive status check
clm-restart              # Restart Colima
clm-upgrade upgrade      # Update Colima and recreate VM
```

#### **🤖 AI Development**
```bash
ai-start                 # Start complete AI environment
ai-status                # AI tools status check
ai-chat                  # Interactive chat with models
cc                       # Claude Code AI assistant
```

#### **☕ Java Development**
```bash
jenv versions            # List available Java versions
jenv global 17.0         # Set global Java version
jenv local 11.0          # Set project-specific version
```

## 📋 Daily Usage

### **System Management**
```bash
bin/dot                  # Update everything
bin/dot --edit           # Open dotfiles for editing
source ~/.zshrc          # Reload shell configuration
```

### **Most Used Commands**
```bash
# Container development
clm-start && clm-status

# Package management
brewcheck && brew-install-missing

# Java projects
jenv local 17.0 && mvn clean install

# AI development
ai-start && ai-chat
```

### **Weekly Maintenance**
```bash
brewupdate              # Update packages
brewlock-update         # Update lock file
clm-upgrade upgrade      # Update Colima
bin/dot                  # Full system update
```

## 🚀 Remote Installation System

### **How It Works**
1. **System Check** - Verifies macOS and installs Xcode tools
2. **Repository Setup** - Clones dotfiles to `~/.dotfiles`
3. **Resume Mechanism** - Sets up automatic resume via Launch Agent
4. **Installation** - Runs `bin/dot` for complete setup
5. **Restart Handling** - Manages macOS updates automatically
6. **Completion** - Cleans up resume mechanism

### **Restart Handling**
- **macOS Update Detection** - Identifies when updates require restart
- **Automatic Resume** - Continues after reboot via Launch Agent
- **Progress Preservation** - Maintains state across restarts
- **Graceful Cleanup** - Removes resume mechanism when complete

### **Timeline**
- **Initial Setup**: 2-5 minutes
- **First Phase**: 5-10 minutes (Homebrew, packages)
- **macOS Updates**: 5-30 minutes (varies)
- **Final Phase**: 2-5 minutes
- **Total**: 15-50 minutes depending on updates

## 🏢 Work Environment Management

### **Architecture**
```
~/.dotfiles/                    # Main public repository
└── work/                       # Private submodule
    ├── 09_zsh/                 # Work shell overrides
    ├── 10_ssh/                 # Corporate SSH configs
    ├── 11_git/                 # Work Git settings
    ├── 12_gh/                  # Corporate GitHub CLI
    ├── 15_node/                # Corporate npm configs
    └── 15_company_tools/       # Company-specific tools
```

### **Security Best Practices**
- ✅ **Main dotfiles**: Public repository
- ✅ **Work configs**: Private corporate repository
- ✅ **No cross-contamination**: Work secrets never touch public repo
- 🔐 **Corporate authentication** required for work repository

### **Daily Workflow**
```bash
# Update both repositories
cd ~/.dotfiles && git pull
cd ~/.dotfiles/work && git pull

# Or use main management command
bin/dot  # Updates both automatically
```

## 📊 Pattern Analysis

### **Consistency Scores**
- **Directory numbering**: 100% ✅
- **File naming conventions**: 95% ✅
- **Symlink patterns**: 100% ✅
- **Install script presence**: 93% (14/15) 🟡
- **Helper integration**: 60% 🟠

### **Identified Areas for Improvement**
1. **Missing install.sh** in `03_zsh/` directory
2. **Script header variations** across components
3. **Inconsistent helper.sh usage** in older scripts
4. **Mixed error handling** approaches

### **Strengths**
- **Clear organization** with numbered directories
- **Modular design** for easy extension
- **Work separation** maintains security
- **Modern additions** follow best practices

## 🔍 Troubleshooting

### **Remote Installation Issues**
```bash
# Check resume status
bin/dotfiles-resume status

# Check installation log
tail -f ~/.dotfiles-install.log

# Manual cleanup if needed
bin/dotfiles-resume cleanup
```

### **Container Issues**
```bash
clm-trouble system-info    # Show system information
clm-trouble logs          # Show Colima logs
clm-trouble reset         # Reset and clean restart
```

### **General Debugging**
```bash
brewcheck                 # Verify app installations
clm-status               # Check container environment
ai-status                # Check AI tools
dotfiles-registry tools   # Check tool installation status
```

## 🤝 Contributing

### **Adding New Components**
1. **Follow numbered directory pattern** for installation order
2. **Include install.sh** with proper error handling
3. **Use helper.sh functions** (`info`, `success`, `fail`)
4. **Add *.zsh files** for shell integration
5. **Test on fresh system** before committing

### **Pattern Compliance**
- Use consistent script headers
- Implement proper error handling with `set -e`
- Integrate with `helper.sh` utility functions
- Follow naming conventions for aliases and functions

## ✅ System Requirements

- **macOS** (tested on recent versions)
- **Bash/Zsh shell**
- **Internet connection** for package downloads
- **Administrator privileges** for some installations

## 📚 Advanced Topics

### **Symlink Management**
- Files ending in `.symlink` are automatically linked to `~/.{filename}`
- Bootstrap script handles creation with interactive prompts
- Helper functions manage backups and overwrites

### **Environment Variables**
- `DOCKER_HOST` - Points to Colima socket
- `TESTCONTAINERS_*` - Configured for Colima
- `JAVA_HOME` - Managed by jenv
- `DOTFILES` - Set to `$HOME/.dotfiles`

### **Shell Integration**
- PATH management across all tools
- Automatic loading of aliases and functions
- Environment setup for development tools
- Work overrides applied automatically

---

*This dotfiles repository provides a complete, modular development environment setup with strong organizational patterns, extensive automation, and comprehensive tool integration for modern macOS development workflows.*