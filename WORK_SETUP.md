# Work Environment Setup Guide

This guide explains how to set up work-specific configurations using a git submodule approach that keeps personal and professional dotfiles separate.

## Overview

The work submodule system allows you to:
- Keep work-specific configurations separate from personal dotfiles
- Maintain different repositories for personal vs. work environments
- Automatically update work configurations when running `bin/dot`
- Follow the same numbered directory structure as the main dotfiles

## Quick Setup

### Option 1: Create New Work Repository

```bash
# 1. Create a new work-specific dotfiles repository
# (Do this on GitHub/GitLab/etc. first, then clone)

# 2. Add as submodule to your dotfiles
cd ~/.dotfiles
git submodule add https://github.com/YOUR_USERNAME/work-dotfiles.git work

# 3. Initialize the work repository structure
cd work
mkdir -p {01_work_brew,02_work_git,03_work_zsh,05_work_tools}

# 4. Create initial work configuration
echo "# Work-specific configurations" > README.md

# 5. Commit and push
git add .
git commit -m "Initial work dotfiles structure"
git push origin main

# 6. Return to main dotfiles and commit submodule
cd ..
git add .gitmodules work
git commit -m "Add work submodule for work-specific configurations"
git push origin main
```

### Option 2: Add Existing Work Repository

```bash
# If you already have a work dotfiles repository
cd ~/.dotfiles
git submodule add https://github.com/YOUR_WORK/work-dotfiles.git work
git commit -m "Add existing work repository as submodule"
git push origin main
```

## Work Repository Structure

Your work repository should follow the same numbered directory pattern:

```
work/
├── README.md
├── 01_work_brew/
│   ├── install.sh          # Work-specific Homebrew packages
│   └── Brewfile           # Work tools and applications
├── 02_work_git/
│   ├── install.sh          # Work git configuration
│   └── gitconfig.work.symlink
├── 03_work_zsh/
│   ├── install.sh          # Work-specific shell setup
│   └── work_aliases.zsh    # Work aliases and functions
├── 05_work_tools/
│   ├── install.sh          # Work-specific development tools
│   └── work_env.sh         # Work environment variables
└── 99_work_secrets/        # Work-specific secrets (add to .gitignore!)
    ├── install.sh
    └── .env.work
```

## Example Work Configurations

### Work Brewfile (`work/01_work_brew/Brewfile`)

```ruby
# Work-specific applications
cask "slack"
cask "zoom"
cask "microsoft-teams"
cask "1password-business"

# Work development tools
brew "awscli"
brew "kubectl"
brew "terraform"
brew "vault"

# Company-specific tools
brew "your-company/tap/internal-tool"
```

### Work Git Config (`work/02_work_git/install.sh`)

```bash
#!/usr/bin/env bash

source "$(dirname "$0")/../../helper.sh"

info "Setting up work git configuration"

# Set work-specific git config
git config --global user.work.name "Your Name"
git config --global user.work.email "you@company.com"

# Configure work-specific settings
git config --global work.company "Company Name"

success "Work git configuration completed"
```

### Work Environment (`work/05_work_tools/work_env.sh`)

```bash
# Work-specific environment variables
export WORK_ENV="production"
export COMPANY_API_URL="https://api.company.com"
export KUBECONFIG="$HOME/.kube/work-config"

# Work-specific aliases
alias work-vpn="sudo openconnect company.com"
alias work-kubectl="kubectl --context=work"
alias work-ssh="ssh -F ~/.ssh/work_config"
```

## Integration with Main Dotfiles

The work submodule integrates automatically with your main dotfiles:

### Automatic Updates
When you run `bin/dot`, it automatically:
1. Checks if `work/` directory exists and is a git repository
2. Runs `git pull origin main` to update work configurations
3. Executes any `install.sh` scripts in work subdirectories

### Symlink Integration
Work configurations can use symlinks just like main dotfiles:
- Files ending in `.symlink` get linked to your home directory
- Prefixed with the directory name to avoid conflicts

### Environment Loading
Add work environment loading to your main shell configuration:

In `03_zsh/zshrc.symlink`, add:
```bash
# Load work-specific configurations if available
if [[ -d "$DOTFILES/work" ]]; then
    for work_config in "$DOTFILES/work"/**/*.zsh; do
        [[ -r "$work_config" ]] && source "$work_config"
    done
fi
```

## Security Considerations

### Secrets Management
- Never commit secrets directly to git repositories
- Use environment files that are git-ignored
- Consider using secret management tools (1Password CLI, etc.)

### Repository Access
- Use separate repositories for work vs. personal configurations
- Ensure work repository follows company security policies
- Consider using SSH keys specific to work contexts

### Example `.gitignore` for work repository:
```
# Secrets and sensitive files
.env*
**/secrets/
**/*.key
**/*.pem
**/credentials*

# Company-specific ignore patterns
internal-configs/
proprietary-tools/
```

## Troubleshooting

### Work Submodule Not Updating
```bash
cd ~/.dotfiles/work
git status
git pull origin main
```

### Missing Work Directory
```bash
cd ~/.dotfiles
git submodule update --init --recursive
```

### Work Configurations Not Loading
Check that:
1. Work repository follows numbered directory structure
2. `install.sh` scripts are executable: `chmod +x work/*/install.sh`
3. Shell configuration includes work environment loading

### Removing Work Submodule
```bash
cd ~/.dotfiles
git submodule deinit -f work
git rm work
git commit -m "Remove work submodule"
```

## Best Practices

1. **Separate Concerns**: Keep work and personal configurations completely separate
2. **Follow Structure**: Use the same numbered directory pattern as main dotfiles
3. **Document Changes**: Include README files explaining work-specific setups
4. **Test Regularly**: Run `bin/dot` to ensure work configurations stay updated
5. **Secure Secrets**: Never commit sensitive information to version control
6. **Team Coordination**: Consider sharing work dotfiles with team members

## Example Complete Setup

See the `examples/work-dotfiles/` directory (if available) for a complete example work repository structure.

For questions or issues with work environment setup, consult your team's documentation or IT security policies.