# 🚀 Dotfiles Quick Reference

Essential commands and shortcuts for daily use of your dotfiles environment.

## 📦 Installation & Setup

```bash
# Initial setup
./bootstrap              # Create symlinks
./install               # Install all components
bin/dot                 # Full system update

# Individual components
./01_homebrew/install.sh # Install homebrew packages
./04_colima/install.sh   # Setup container runtime
./05_java/install.sh     # Configure Java environment
```

## 🍺 Package Management

```bash
# Check installation status
brewcheck               # Show what's installed vs missing
brew-status            # Show Brewfile statistics

# Install & update
brewfile               # Install from Brewfile
brew-install-missing   # Interactive install of missing apps
brewupdate             # Update homebrew & upgrade packages
brewclean              # Cleanup unused packages
```

## 🐳 Container Development

```bash
# Daily operations
clm-start              # Start Colima with optimal settings
clm-stop               # Stop Colima
clm-status             # Show comprehensive status
clm-restart            # Restart Colima

# Configuration
clm-socket check       # Verify Docker socket setup
clm-socket link        # Link socket to standard location
clm-ctx list           # List Docker contexts
clm-ctx switch <name>  # Switch Docker context

# Maintenance
clm-upgrade upgrade    # Upgrade Colima
clm-upgrade recreate   # Recreate VM
clm-trouble reset      # Reset and clean restart
```

## ☕ Java Development

```bash
# Version management
jenv versions          # List available Java versions
jenv global 17.0       # Set global Java version
jenv local 11.0        # Set project-specific version
jenv which java        # Show current Java path

# Quick switching
export JAVA_HOME=$(jenv javahome)  # Set JAVA_HOME
```

## 🔧 System Management

```bash
# Daily maintenance
bin/dot                # Update everything
bin/dot --edit         # Open dotfiles for editing

# Shell management
source ~/.zshrc        # Reload shell configuration
clm-help              # Show Colima helpers
brew-help             # Show Homebrew helpers
```

## 📁 Directory Navigation

```bash
# Core directories
~/.dotfiles            # Main dotfiles repository
~/.dotfiles/work       # Work-specific configurations
~/.dotfiles/04_colima/helpers  # Container management scripts
~/.dotfiles/01_homebrew        # Package management
```

## 🔍 Troubleshooting

```bash
# Colima issues
clm-trouble system-info    # Show system information
clm-trouble logs          # Show Colima logs
clm-trouble cleanup       # Clean Docker resources
clm-trouble fix-permissions  # Fix socket permissions

# General debugging
brewcheck                 # Verify app installations
clm-status               # Check container environment
jenv doctor              # Check Java environment
```

## 🌟 Most Used Commands

### **Container Development**
```bash
clm-start && clm-status   # Start and verify Colima
docker ps                 # List running containers
```

### **Package Management**
```bash
brewcheck && brew-install-missing  # Check and install missing apps
brewupdate                         # Keep packages current
```

### **Java Projects**
```bash
jenv local 17.0           # Set Java 17 for current project
mvn clean install        # Build with current Java version
```

### **Daily Updates**
```bash
bin/dot                   # Update entire system
brewupdate               # Update packages
clm-upgrade check-version # Check for Colima updates
```

## 💡 Pro Tips

### **Aliases Available**
- `clm` = `colima`
- `brewfile` = `brew bundle install --file=Brewfile`
- `brewclean` = `brew cleanup && brew autoremove`

### **Environment Variables Set**
- `DOCKER_HOST` - Points to Colima socket
- `TESTCONTAINERS_*` - Configured for Colima
- `JAVA_HOME` - Managed by jenv

### **Automatic Features**
- **PATH management** - All tools properly prioritized
- **Shell integration** - Aliases and functions loaded automatically
- **Environment setup** - Development tools configured on shell start
- **Work overrides** - Company settings applied automatically

## 🆘 Emergency Commands

```bash
# Nuclear options (use with caution)
clm-upgrade recreate      # Completely recreate Colima VM
clm-trouble reset         # Reset Colima to defaults
brew cleanup --prune=all # Remove all old package versions
```

---

*Save this reference for quick access to your most commonly used dotfiles commands!*