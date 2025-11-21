#!/usr/bin/env bash
#
# Docker context management helpers
#

set -e

ACTION="${1:-list}"

case "$ACTION" in
    "list"|"ls")
        echo "Available Docker contexts:"
        docker context ls
        echo ""
        echo "Current context: $(docker context show)"
        ;;
    "switch"|"use")
        CONTEXT="${2:-colima}"
        if docker context ls | grep -q "$CONTEXT"; then
            docker context use "$CONTEXT"
            echo "✅ Switched to Docker context: $CONTEXT"
        else
            echo "❌ Context '$CONTEXT' not found"
            echo "Available contexts:"
            docker context ls --format "table {{.Name}}\t{{.Description}}"
            exit 1
        fi
        ;;
    "create")
        CONTEXT_NAME="${2}"
        SOCKET_PATH="${3}"
        if [ -z "$CONTEXT_NAME" ] || [ -z "$SOCKET_PATH" ]; then
            echo "Usage: $0 create <context-name> <socket-path>"
            echo "Example: $0 create colima-dev unix://\$HOME/.colima/dev/docker.sock"
            exit 1
        fi
        docker context create "$CONTEXT_NAME" --docker "host=$SOCKET_PATH"
        echo "✅ Created Docker context: $CONTEXT_NAME"
        ;;
    "remove"|"rm")
        CONTEXT="${2}"
        if [ -z "$CONTEXT" ]; then
            echo "Usage: $0 remove <context-name>"
            exit 1
        fi
        if [ "$CONTEXT" = "default" ]; then
            echo "❌ Cannot remove default context"
            exit 1
        fi
        docker context rm "$CONTEXT"
        echo "✅ Removed Docker context: $CONTEXT"
        ;;
    "help"|*)
        echo "Docker context management helper"
        echo ""
        echo "Usage: $0 <action> [args...]"
        echo ""
        echo "Actions:"
        echo "  list, ls              List all Docker contexts"
        echo "  switch, use <name>    Switch to a Docker context"
        echo "  create <name> <path>  Create a new Docker context"
        echo "  remove, rm <name>     Remove a Docker context"
        echo "  help                  Show this help"
        ;;
esac