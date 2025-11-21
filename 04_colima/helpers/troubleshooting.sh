#!/usr/bin/env bash
#
# Colima troubleshooting helpers
#
# Add your custom troubleshooting scripts and snippets here

set -e

ACTION="${1:-help}"

case "$ACTION" in
    "reset")
        echo "🔄 Resetting colima (this will stop and delete the current instance)..."
        read -p "Are you sure? This will delete all containers and images! (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            colima stop || true
            colima delete || true
            echo "✅ Colima reset complete. Run 'colima start' to create a fresh instance."
        else
            echo "Cancelled."
        fi
        ;;
    "logs")
        echo "📄 Colima logs:"
        colima logs || echo "No logs available"
        ;;
    "cleanup")
        echo "🧹 Cleaning up Docker resources..."
        if docker info >/dev/null 2>&1; then
            echo "Removing stopped containers..."
            docker container prune -f || true
            echo "Removing unused images..."
            docker image prune -f || true
            echo "Removing unused volumes..."
            docker volume prune -f || true
            echo "Removing unused networks..."
            docker network prune -f || true
            echo "✅ Cleanup complete"
        else
            echo "❌ Docker is not running"
        fi
        ;;
    "fix-permissions")
        echo "🔧 Fixing Docker socket permissions..."
        SCRIPT_DIR="$(dirname "$0")"
        "$SCRIPT_DIR/socket-helper.sh" fix-permissions
        ;;
    "system-info")
        echo "💻 System information for troubleshooting:"
        echo "OS: $(uname -s) $(uname -r)"
        echo "Architecture: $(uname -m)"
        echo "Shell: $SHELL"
        if command -v brew >/dev/null 2>&1; then
            echo "Homebrew: $(brew --version | head -1)"
        fi
        echo ""
        echo "Environment variables:"
        env | grep -E "(DOCKER|COLIMA|TESTCONTAINERS)" || echo "No Docker/Colima/Testcontainers environment variables set"
        ;;
    "help"|*)
        echo "Colima troubleshooting helper"
        echo ""
        echo "Usage: $0 <action>"
        echo ""
        echo "Actions:"
        echo "  reset           Reset colima (delete and recreate)"
        echo "  logs            Show colima logs"
        echo "  cleanup         Clean up Docker resources (containers, images, volumes)"
        echo "  fix-permissions Fix Docker socket permissions"
        echo "  system-info     Show system information for debugging"
        echo "  help            Show this help"
        echo ""
        echo "💡 Additional helpers:"
        echo "  clm-socket check    Check Docker socket configuration"
        echo "  clm-socket link     Link colima socket to /var/run/docker.sock"
        echo ""
        echo "💡 Add your custom troubleshooting snippets to this script!"
        ;;
esac