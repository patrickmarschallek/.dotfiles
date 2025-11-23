# 🚀 Remote Installation Guide

A one-command installation system for setting up dotfiles on fresh macOS machines with automatic restart handling and update checking.

## 🎯 Quick Start

### **One-Command Installation**
```bash
curl -fsSL https://raw.githubusercontent.com/patrickmarschallek/.dotfiles/main/install-remote.sh | bash
```

This single command will:
- ✅ **Download and install** all dotfiles automatically
- ✅ **Handle macOS updates** and restart cycles seamlessly
- ✅ **Resume installation** after each reboot automatically
- ✅ **Setup automatic update checking** for daily maintenance
- ✅ **Clean up** resume mechanisms when complete

## 🏗️ How It Works

### **Streamlined Installation Flow**
1. **System Check** - Verifies macOS and installs Xcode Command Line Tools (includes git)
2. **Repository Setup** - Clones dotfiles repository to `~/.dotfiles`
3. **Resume Mechanism** - Sets up automatic resume using `bin/dotfiles-resume`
4. **Main Installation** - Runs existing `bin/dot` command for all setup
5. **Automatic Restart** - Handles macOS updates and resumes after reboots
6. **Completion** - Cleans up resume mechanism when finished

### **Key Improvements**
- ✅ **No Redundancy** - Uses existing `bin/dot` command instead of duplicating logic
- ✅ **Reusable Resume** - `bin/dotfiles-resume` is part of dotfiles, not temporary
- ✅ **Simplified Flow** - Remote installer just gets repo and runs existing tools
- ✅ **Consistent Experience** - Same installation process whether remote or local

### **Restart Handling**
- **Launch Agent** - Automatically resumes installation after reboots
- **Progress Tracking** - Maintains installation state across restarts
- **Update Detection** - Checks for pending macOS updates
- **Scheduled Restart** - Gracefully handles required restarts
- **Automatic Cleanup** - Removes resume mechanism when complete

## 📁 Installation Files

### **Created During Installation**
```
~/
├── .dotfiles/                           # Main dotfiles repository
│   └── bin/dotfiles-resume             # Resume script (part of repo)
├── .dotfiles-install.log               # Detailed installation log
├── .dotfiles-installation-complete     # Completion marker (temporary)
└── Library/LaunchAgents/
    └── com.dotfiles.resume.plist       # Auto-resume agent (temporary)
```

### **Permanent Files After Installation**
```
~/
├── .dotfiles/                    # Complete dotfiles setup
│   ├── bin/dot                  # Main management command
│   ├── bin/dotfiles-resume      # Resume script (reusable)
│   └── ...                      # All dotfiles components
└── .dotfiles-install.log        # Installation history
```

## 🔧 Features

### **Automatic Restart Handling**
- **macOS Update Detection** - Identifies when updates require restart
- **Graceful Restart** - 60-second warning before scheduled restart
- **Automatic Resume** - Continues installation after reboot
- **Progress Preservation** - Maintains state across restart cycles
- **Final Cleanup** - Removes resume mechanism when complete

### **Update Checking System**
- **Daily Checks** - Automatically checks for dotfiles updates
- **Background Operation** - Non-intrusive background checking
- **Smart Notifications** - Only notifies when updates available
- **Throttled Checking** - Respects 24-hour check intervals
- **Silent Failures** - Gracefully handles network issues

### **Robust Error Handling**
- **Comprehensive Logging** - Detailed logs for troubleshooting
- **Resume Capability** - Recovers from interruptions
- **System Validation** - Verifies macOS compatibility
- **Prerequisite Installation** - Ensures Xcode tools are available
- **Cleanup on Completion** - Removes temporary files

## 📋 Usage Examples

### **Fresh Machine Setup**
```bash
# On a brand new Mac - single command does everything
curl -fsSL https://raw.githubusercontent.com/patrickmarschallek/.dotfiles/main/install-remote.sh | bash

# Installation will:
# 1. Install Xcode Command Line Tools (if needed)
# 2. Clone dotfiles repository
# 3. Run all installations
# 4. Handle any required restarts automatically
# 5. Setup daily update checking
# 6. Complete installation
```

### **Manual Installation Check**
```bash
# Check resume status
bin/dotfiles-resume status

# View installation log
tail -f ~/.dotfiles-install.log

# Check if installation is complete
test -f ~/.dotfiles-installation-complete && echo "Complete" || echo "In Progress"
```

### **Update Checking**
```bash
# Manual update check (runs automatically daily)
~/.dotfiles-update-check.sh

# Update dotfiles manually
cd ~/.dotfiles && bin/dot
```

## 🔍 Troubleshooting

### **Installation Issues**

**Problem**: Installation seems stuck
```bash
# Check resume status
cd ~/.dotfiles && bin/dotfiles-resume status

# Check installation log
tail -20 ~/.dotfiles-install.log
```

**Problem**: Restart loop not working
```bash
# Check launch agent status
launchctl list | grep com.dotfiles.resume

# Manually run resume
cd ~/.dotfiles && bin/dotfiles-resume run
```

**Problem**: Installation incomplete after multiple restarts
```bash
# Remove completion marker and restart
rm -f ~/.dotfiles-installation-complete
cd ~/.dotfiles && bin/dotfiles-resume run
```

### **Manual Cleanup**
```bash
# Clean up using the built-in command
cd ~/.dotfiles && bin/dotfiles-resume cleanup

# Or manually clean up if needed
rm -f ~/.dotfiles-installation-complete
rm -f ~/Library/LaunchAgents/com.dotfiles.resume.plist
launchctl unload ~/Library/LaunchAgents/com.dotfiles.resume.plist 2>/dev/null || true

# Then restart installation
curl -fsSL https://raw.githubusercontent.com/patrickmarschallek/.dotfiles/main/install-remote.sh | bash
```

## 🛡️ Security Considerations

### **Script Safety**
- **HTTPS Download** - Script downloaded over secure connection
- **No sudo by default** - Only requests elevated privileges when needed
- **Transparent operations** - All actions logged and visible
- **Reversible changes** - Installation can be undone

### **Network Requirements**
- **Internet connection** - Required for downloading packages
- **GitHub access** - Repository must be accessible
- **Homebrew downloads** - Package manager requires network access

## ⚙️ Customization

### **Repository URL**
Edit the script to use your own fork:
```bash
# Download and modify
curl -fsSL https://raw.githubusercontent.com/patrickmarschallek/.dotfiles/main/install-remote.sh > install-custom.sh

# Edit DOTFILES_REPO variable
sed -i '' 's|patrickmarschallek|yourusername|g' install-custom.sh

# Use your customized version
bash install-custom.sh
```

### **Installation Directory**
```bash
# Change DOTFILES_DIR in the script for custom location
DOTFILES_DIR="$HOME/my-dotfiles"
```

## 📊 Installation Timeline

### **Typical Fresh Machine Installation**
1. **Initial Setup** (2-5 minutes)
   - Xcode Command Line Tools
   - Repository cloning
   - Resume mechanism setup

2. **First Installation Phase** (5-10 minutes)
   - Homebrew installation
   - Package downloads
   - Configuration setup

3. **macOS Updates** (5-30 minutes, varies)
   - System update download and installation
   - Automatic restart
   - Resume after reboot

4. **Final Phase** (2-5 minutes)
   - Remaining package installations
   - Final configuration
   - Cleanup and completion

**Total Time**: 15-50 minutes (depending on macOS updates and internet speed)

## ✅ Success Indicators

### **Installation Complete**
- ✅ File `~/.dotfiles-complete` exists
- ✅ No resume script in home directory
- ✅ Launch agent removed
- ✅ Update checking configured in `.zshrc`
- ✅ All numbered directories (00_-08_) present in `~/.dotfiles/`

### **Tools Available**
```bash
# Test key tools
which brew                    # Homebrew package manager
dotfiles-registry summary     # Tool discovery system
bin/dot --help               # Management command
clm-status                   # Colima container runtime
```

---

*This remote installation system provides a seamless, hands-off experience for setting up development environments on fresh macOS machines.*