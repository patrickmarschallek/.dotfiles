# 🏢 Work Submodule Management Guide

A comprehensive guide for managing work-specific dotfiles as a private git submodule while keeping your main dotfiles public.

## 🎯 Overview

This setup allows you to:
- **Keep main dotfiles public** on GitHub
- **Keep work configs private** in a separate corporate repository
- **Maintain separate versioning** for personal vs work configurations
- **Ensure security** by preventing accidental exposure of corporate information

## 🏗️ Architecture Pattern

```
~/.dotfiles/                    # Main public repository
├── 00_macos/                   # Public configurations
├── 01_homebrew/                # ...
├── ...                         # ...
└── work/                       # Private submodule
    ├── 09_zsh/                 # Work shell overrides
    ├── 10_ssh/                 # Corporate SSH configs
    ├── 11_git/                 # Work Git settings
    ├── 12_gh/                  # Corporate GitHub CLI
    ├── 15_node/                # Corporate npm configs
    └── 15_company_tools/       # Company-specific development tools
```

## 🔧 Setup Instructions

### **1. Initial Setup**
Set up your work directory as a separate git repository:
- **Private Remote**: Your corporate GitHub or internal Git server
- **Separate Versioning**: Independent commits from main dotfiles
- **Private Access**: Only accessible to authorized team members

### **2. Proper Submodule Registration**

If you want to formalize it as a git submodule in the main repository:

```bash
# From main dotfiles directory
cd ~/.dotfiles

# Remove work directory from staging (if present)
git rm --cached work 2>/dev/null || true

# Add as proper submodule (replace with your work repository URL)
git submodule add https://your-corporate-git-server/your-username/work-dotfiles.git work

# Commit the submodule configuration
git add .gitmodules work
git commit -m "Add work configurations as private submodule"
```

### **3. Alternative: Independent Management (Current Setup)**

Keep work directory independent (recommended for maximum security):

```bash
# Add work to main repository's .gitignore
echo "work/" >> .gitignore
git add .gitignore
git commit -m "Ignore work directory - managed independently"
```

## 🔒 Security Best Practices

### **Repository Separation**
- ✅ **Main dotfiles**: Public repository (GitHub, GitLab, etc.)
- ✅ **Work configs**: Private corporate repository (internal Git server)
- ✅ **No cross-contamination**: Work secrets never touch public repo

### **Access Control**
- 🔐 **Corporate authentication** required for work repository
- 🏢 **Network restrictions** (corporate VPN/network access)
- 👥 **Team access** can be managed independently

### **Content Guidelines**
**NEVER include in work repository:**
- ❌ Personal API keys or tokens
- ❌ Non-work related private information
- ❌ Anything that shouldn't be in corporate systems

**ALWAYS include in work repository:**
- ✅ Corporate email configurations
- ✅ Company-specific tool settings
- ✅ Team collaboration shortcuts
- ✅ Corporate network configurations

## 📋 Daily Workflow

### **Working with Both Repositories**

```bash
# Update main (public) dotfiles
cd ~/.dotfiles
git pull origin main
./install

# Update work (private) configurations
cd ~/.dotfiles/work
git pull origin main

# Or update both at once
cd ~/.dotfiles
git pull --recurse-submodules  # If using formal submodule
```

### **Making Changes**

```bash
# Changes to main dotfiles
cd ~/.dotfiles
# Make changes...
git add .
git commit -m "Update main configuration"
git push origin main

# Changes to work configurations
cd ~/.dotfiles/work
# Make changes...
git add .
git commit -m "Update work configuration"
git push origin main
```

## 🚀 Installation on New Machine

### **Option 1: Clone with Submodule (Formal Setup)**
```bash
# Clone main repository with work submodule
git clone --recurse-submodules https://github.com/your-username/.dotfiles.git ~/.dotfiles

# Install everything
cd ~/.dotfiles
./install
```

### **Option 2: Independent Clone (Current Setup)**
```bash
# Clone main public repository
git clone https://github.com/your-username/.dotfiles.git ~/.dotfiles

# Clone work repository separately (replace with your work repository URL)
cd ~/.dotfiles
git clone https://your-corporate-git-server/your-username/work-dotfiles.git work

# Install everything
./install
```

## 🔄 Synchronization Strategies

### **Automatic Updates**
Add to your main `bin/dot` script:
```bash
# Update work configurations if available
if [ -d "$DOTFILES/work" ] && [ -d "$DOTFILES/work/.git" ]; then
    info "updating work configurations"
    cd "$DOTFILES/work"
    git pull origin main || true
    cd "$DOTFILES"
fi
```

### **Manual Sync Commands**
```bash
# Check status of both repositories
cd ~/.dotfiles && git status
cd ~/.dotfiles/work && git status

# Pull updates from both
cd ~/.dotfiles && git pull
cd ~/.dotfiles/work && git pull
```

## 🛠️ Maintenance

### **Backup Strategy**
- **Main dotfiles**: Backed up on public GitHub
- **Work configs**: Backed up on corporate GitHub
- **Local backups**: Regular system backups include both

### **Access Management**
- **Personal access**: Your GitHub account for main repo
- **Corporate access**: Your corporate account for work repo
- **Team sharing**: Corporate repo can be shared with team members

### **Version Management**
- **Independent versioning**: Each repository has its own history
- **Coordinated releases**: Tag versions when stable configurations are reached
- **Rollback capability**: Can rollback main and work configs independently

## 🚨 Troubleshooting

### **Submodule Issues**
```bash
# Reset submodule if corrupted
git submodule update --init --recursive

# Force update submodule
git submodule update --remote work
```

### **Access Issues**
```bash
# Check work repository access
cd ~/.dotfiles/work
git remote -v
git fetch origin  # Test connectivity
```

### **Synchronization Problems**
```bash
# Verify both repositories are clean
cd ~/.dotfiles && git status
cd ~/.dotfiles/work && git status

# Reset if needed
cd ~/.dotfiles/work
git reset --hard origin/main
```

## 📚 Documentation Management

### **Main Repository Documentation**
- Keep work-related documentation minimal in main repo
- Reference work submodule without exposing corporate details
- Maintain general setup instructions

### **Work Repository Documentation**
- Detailed corporate-specific setup instructions
- Team onboarding guides
- Corporate tool configurations
- Internal process documentation

## 🔍 Integration with Tools Registry

Your `dotfiles-registry` tool automatically discovers work tools:
```bash
dotfiles-registry tools          # Shows both main and work tools
dotfiles-registry search company # Finds corporate tools
```

Work-specific aliases and functions are automatically loaded during shell initialization.

## ✅ Verification Checklist

- [ ] Work directory is separate git repository
- [ ] Work repository is on corporate GitHub
- [ ] Main repository .gitignore excludes work directory
- [ ] No corporate secrets in main repository
- [ ] Installation works on fresh machine
- [ ] Both repositories can be updated independently
- [ ] Access controls are properly configured

---

*This setup ensures maximum security while maintaining development productivity across personal and corporate environments.*