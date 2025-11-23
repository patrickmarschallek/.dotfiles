# 🎯 Dotfiles Tools Registry

A comprehensive registry of all available tools, aliases, functions, and helper scripts in your dotfiles.

> **Quick Discovery**: Run `dotfiles-registry summary` for an overview or `dotfiles-registry help` for interactive exploration.

## 📊 Overview

- **36 Aliases** - Quick shortcuts for common commands
- **16 Functions** - Advanced workflow automation
- **9 Helper Scripts** - Specialized management tools
- **15 Components** - Modular dotfiles sections

## 🍺 Homebrew Package Management

### Aliases
| Alias | Command | Purpose |
|-------|---------|---------|
| `brewfile` | `brew bundle install --file=Brewfile` | Install all packages |
| `brewcheck` | `check-apps.sh` | Check installation status |
| `brewclean` | `brew cleanup && brew autoremove` | Clean unused packages |
| `brewupdate` | `brew update && brew upgrade` | Update all packages |
| `brewlock-update` | Update Brewfile.lock.json | Update lock file |
| `brewlock-regenerate` | Regenerate Brewfile.lock.json | Recreate lock file |

### Functions
| Function | Purpose |
|----------|---------|
| `brew-help()` | Show all homebrew helper commands |
| `brew-install-missing()` | Interactive install of missing applications |
| `brew-lock()` | Advanced Brewfile.lock.json management |
| `brew-status()` | Show Brewfile statistics and lock file status |

## 🐳 Container Development (Colima)

### Aliases
| Alias | Command | Purpose |
|-------|---------|---------|
| `clm` | `colima` | Colima command shortcut |
| `clm-start` | `colima-start.sh` | Start Colima with optimal settings |
| `clm-stop` | `colima-stop.sh` | Stop Colima profile(s) |
| `clm-status` | `colima-status.sh` | Comprehensive status check |
| `clm-ctx` | `docker-context.sh` | Docker context management |
| `clm-socket` | `socket-helper.sh` | Docker socket management |
| `clm-upgrade` | `colima-upgrade.sh` | Upgrade and VM recreation |
| `clm-trouble` | `troubleshooting.sh` | Troubleshooting helpers |

### Functions
| Function | Purpose |
|----------|---------|
| `clm-help()` | Show all colima helper commands |
| `clm-quick-start()` | Quick start with default resources |
| `clm-recreate-light()` | Recreate VM with light resources (2 CPU, 4GB) |
| `clm-restart()` | Restart colima profile |
| `clm-upgrade-quick()` | Quick colima upgrade |
| `clm-use()` | Switch Docker context |

### Helper Scripts
| Script | Purpose |
|--------|---------|
| `colima-start.sh` | Advanced startup with profiles and networking |
| `colima-stop.sh` | Flexible shutdown for all profiles |
| `colima-status.sh` | Comprehensive status and environment checks |
| `colima-upgrade.sh` | Upgrade colima and recreate VMs |
| `docker-context.sh` | Docker context management |
| `socket-helper.sh` | Docker socket linking and permissions |
| `troubleshooting.sh` | Reset, cleanup, and diagnostics |

## 🤖 AI Development Tools

### Aliases
| Alias | Command | Purpose |
|-------|---------|---------|
| `cc` | `claude-code` | Claude Code AI assistant |
| `ollama-start` | `ollama-helper.sh start` | Start Ollama service |
| `ollama-stop` | `ollama-helper.sh stop` | Stop Ollama service |
| `ollama-status` | `ollama-helper.sh status` | Ollama status check |
| `ollama-models` | `ollama-helper.sh models` | List/manage models |
| `webui` | `webui-helper.sh` | Open WebUI management |
| `webui-start` | `webui-helper.sh start` | Start Open WebUI |
| `webui-stop` | `webui-helper.sh stop` | Stop Open WebUI |
| `webui-open` | `webui-helper.sh open` | Open WebUI in browser |

### Functions
| Function | Purpose |
|----------|---------|
| `ai-start()` | Start complete AI environment (Ollama + WebUI) |
| `ai-stop()` | Stop all AI services |
| `ai-status()` | Comprehensive AI tools status |
| `ai-pull()` | Download AI models |
| `ai-chat()` | Interactive chat with AI models |
| `ai-dev()` | Show AI development workflow |
| `ai-help()` | Show AI tools helper commands |

### Helper Scripts
| Script | Purpose |
|--------|---------|
| `ollama-helper.sh` | Ollama service and model management |
| `webui-helper.sh` | Open WebUI container management |

## 🔐 Security & GPG

### Aliases
| Alias | Purpose |
|-------|---------|
| `gpg-key-export` | Export GPG public key |
| `gpg-key-list` | List GPG secret keys |
| `pubkey` | Copy SSH public key to clipboard |

## 👥 Work-Specific Tools (Company)

### Aliases
| Alias | Purpose |
|-------|---------|
| `evan` | Quick access approval for Evan |
| `marouan` | Quick access approval for Marouan |
| `max` | Quick access approval for Max |
| `mayuri` | Quick access approval for Mayuri |
| `milad` | Quick access approval for Milad |
| `sergei` | Quick access approval for Sergei |
| `siamand` | Quick access approval for Siamand |

## 🎯 Master Commands

### System Management
| Command | Purpose |
|---------|---------|
| `bin/dot` | Main dotfiles management command |
| `./bootstrap` | Create symlinks for configuration files |
| `./install` | Run all component install scripts |
| `dotfiles-registry` | **NEW** - Discover all available tools |

### Quick Workflows

#### **Daily Development Setup**
```bash
ai-start                # Start AI environment
clm-status             # Check container status
brewcheck              # Verify installations
```

#### **Weekly Maintenance**
```bash
brewupdate            # Update packages
brewlock-update       # Update lock file
clm-upgrade upgrade    # Update Colima
```

#### **Tool Discovery**
```bash
dotfiles-registry summary     # Quick overview
dotfiles-registry search docker # Find docker tools
dotfiles-registry aliases      # List all aliases
```

## 📋 Component Directory Structure

| Directory | Purpose | Install Script | Shell Config |
|-----------|---------|----------------|--------------|
| `00_macos/` | System settings | ✅ | ❌ |
| `01_homebrew/` | Package manager | ✅ | ✅ |
| `01_hyper/` | Terminal config | ✅ | ❌ |
| `01_ssh/` | SSH configuration | ✅ | ❌ |
| `02_git/` | Git & version control | ✅ | ✅ |
| `02_gpg/` | GPG encryption | ✅ | ✅ |
| `02_oh-my-zsh/` | Shell framework | ✅ | ✅ |
| `03_zsh/` | Shell customization | ❌ | ✅ |
| `04_colima/` | Container runtime | ✅ | ✅ |
| `05_gh/` | GitHub CLI | ✅ | ❌ |
| `05_java/` | Java development | ✅ | ✅ |
| `05_node/` | Node.js development | ✅ | ✅ |
| `06_pyenv/` | Python versions | ✅ | ✅ |
| `07_pipenv/` | Python packaging | ✅ | ❌ |
| `07_poetry/` | Python dependency management | ✅ | ✅ |
| `08_ai_tools/` | AI development | ✅ | ✅ |
| `work/` | Work-specific configs | Multiple | ✅ |

## 🔍 Discovery Tools

### Interactive Registry
```bash
dotfiles-registry          # Interactive help
dotfiles-registry summary  # Quick stats overview
dotfiles-registry aliases  # All aliases by category
dotfiles-registry functions # All functions by category
dotfiles-registry helpers  # All helper scripts
dotfiles-registry tools    # Installation status
dotfiles-registry search X # Find anything with X
```

### Manual Discovery
```bash
# Find all aliases
find . -name "*.zsh" -exec grep "^alias " {} \;

# Find all functions
find . -name "*.zsh" -exec grep "^[a-zA-Z_-]*() {" {} \;

# Find all helpers
find . -name "*.sh" -path "*/helpers/*"
```

## 💡 Usage Tips

### **Function vs Alias vs Helper**
- **Aliases** - Simple shortcuts (`cc`, `brewfile`)
- **Functions** - Complex workflows (`ai-start`, `brew-lock`)
- **Helpers** - Standalone scripts (`colima-upgrade.sh`)

### **Naming Patterns**
- **Tool prefix** - `clm-*`, `ai-*`, `brew-*`
- **Action suffix** - `*-start`, `*-stop`, `*-status`
- **Management** - `*-helper`, `*-upgrade`, `*-install`

### **Common Workflows**
1. **Discovery**: `dotfiles-registry summary`
2. **Search**: `dotfiles-registry search docker`
3. **Status**: `ai-status`, `clm-status`, `brew-status`
4. **Help**: `ai-help`, `clm-help`, `brew-help`

---

*This registry is automatically discoverable via `dotfiles-registry` command. Run it for interactive exploration of all available tools!*