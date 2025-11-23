# Colima aliases and functions

# Get the colima dotfiles directory
COLIMA_DOTFILES_DIR="$(dirname "${(%):-%x}")"

# Colima and Docker environment variables
export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"

# Testcontainers configuration for colima
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
export TESTCONTAINERS_RYUK_DISABLED=true

# Set Testcontainers host override dynamically
if command -v colima >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    if colima status >/dev/null 2>&1; then
        export TESTCONTAINERS_HOST_OVERRIDE=$(colima ls -j 2>/dev/null | jq -r '.address' 2>/dev/null || echo "")
    fi
fi

# Aliases for common colima operations
alias clm='colima'
alias clm-start='$COLIMA_DOTFILES_DIR/helpers/colima-start.sh'
alias clm-stop='$COLIMA_DOTFILES_DIR/helpers/colima-stop.sh'
alias clm-status='$COLIMA_DOTFILES_DIR/helpers/colima-status.sh'
alias clm-ctx='$COLIMA_DOTFILES_DIR/helpers/docker-context.sh'
alias clm-socket='$COLIMA_DOTFILES_DIR/helpers/socket-helper.sh'
alias clm-upgrade='$COLIMA_DOTFILES_DIR/helpers/colima-upgrade.sh'
alias clm-trouble='$COLIMA_DOTFILES_DIR/helpers/troubleshooting.sh'

# Quick functions
clm-quick-start() {
    local profile="${1:-default}"
    local cpu="${2:-4}"
    local memory="${3:-8}"
    echo "🚀 Quick starting colima profile: $profile"
    $COLIMA_DOTFILES_DIR/helpers/colima-start.sh "$profile" "$cpu" "$memory"
}

clm-restart() {
    local profile="${1:-default}"
    echo "🔄 Restarting colima profile: $profile"
    $COLIMA_DOTFILES_DIR/helpers/colima-stop.sh "$profile"
    sleep 2
    $COLIMA_DOTFILES_DIR/helpers/colima-start.sh "$profile"
}

# Docker context switching shortcuts
clm-use() {
    $COLIMA_DOTFILES_DIR/helpers/docker-context.sh switch "$1"
}

# Upgrade shortcuts
clm-upgrade-quick() {
    echo "🚀 Quick upgrade and VM recreation with minimal resources..."
    $COLIMA_DOTFILES_DIR/helpers/colima-upgrade.sh upgrade
}

clm-recreate-light() {
    echo "🔄 Recreating VM with light resources (2 CPU, 4GB)..."
    $COLIMA_DOTFILES_DIR/helpers/colima-upgrade.sh recreate default 2 4 60
}

# Show colima help
clm-help() {
    echo "Colima dotfiles helper commands:"
    echo ""
    echo "Aliases:"
    echo "  clm              - colima command"
    echo "  clm-start        - start colima with custom config"
    echo "  clm-stop         - stop colima profile(s)"
    echo "  clm-status       - show comprehensive status"
    echo "  clm-ctx          - Docker context management"
    echo "  clm-socket       - Docker socket management"
    echo "  clm-upgrade      - upgrade and VM recreation"
    echo "  clm-trouble      - troubleshooting helpers"
    echo ""
    echo "Functions:"
    echo "  clm-quick-start [profile] [cpu] [memory] - quick start with defaults"
    echo "  clm-restart [profile]                    - restart a profile"
    echo "  clm-use <context>                        - switch Docker context"
    echo "  clm-upgrade-quick                        - upgrade colima quickly"
    echo "  clm-recreate-light                       - recreate VM with 2 CPU, 4GB"
    echo "  clm-help                                 - show this help"
    echo ""
    echo "Examples:"
    echo "  clm-quick-start dev 6 12    # Start 'dev' profile with 6 CPUs, 12GB RAM"
    echo "  clm-restart                 # Restart default profile"
    echo "  clm-use colima-dev          # Switch to dev Docker context"
}