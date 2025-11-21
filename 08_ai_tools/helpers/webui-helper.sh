#!/usr/bin/env bash
#
# Open WebUI management helper
#

set -e

CONTAINER_NAME="open-webui"
IMAGE_NAME="ghcr.io/open-webui/open-webui:main"
PORT="3000"

ACTION="${1:-help}"

case "$ACTION" in
    "start")
        echo "🚀 Starting Open WebUI..."

        if ! docker info >/dev/null 2>&1; then
            echo "❌ Docker is not running. Please start Colima first:"
            echo "   clm-start"
            exit 1
        fi

        if docker ps --format "table {{.Names}}" | grep -q "$CONTAINER_NAME"; then
            echo "✅ Open WebUI is already running"
        elif docker ps -a --format "table {{.Names}}" | grep -q "$CONTAINER_NAME"; then
            echo "🔄 Starting existing container..."
            docker start "$CONTAINER_NAME"
            echo "✅ Open WebUI started"
        else
            echo "📦 Creating and starting Open WebUI container..."
            docker run -d \
                --name "$CONTAINER_NAME" \
                -p "$PORT:8080" \
                --add-host=host.containers.internal:host-gateway \
                -e WEBUI_AUTH=False \
                -e WEBUI_SECRET_KEY=1234 \
                -v open-webui:/app/backend/data \
                --restart always \
                "$IMAGE_NAME"
            echo "✅ Open WebUI container created and started"
        fi

        echo "🌐 Open WebUI is available at: http://localhost:$PORT"
        ;;
    "stop")
        echo "⏹️ Stopping Open WebUI..."
        if docker ps --format "table {{.Names}}" | grep -q "$CONTAINER_NAME"; then
            docker stop "$CONTAINER_NAME"
            echo "✅ Open WebUI stopped"
        else
            echo "ℹ️ Open WebUI is not running"
        fi
        ;;
    "restart")
        echo "🔄 Restarting Open WebUI..."
        $0 stop
        sleep 2
        $0 start
        ;;
    "status")
        echo "📊 Open WebUI Status"
        echo "===================="

        if ! docker info >/dev/null 2>&1; then
            echo "❌ Docker is not running"
            echo "💡 Start Docker with: clm-start"
            exit 1
        fi

        if docker ps --format "table {{.Names}}" | grep -q "$CONTAINER_NAME"; then
            echo "✅ Status: Running"
            echo "🌐 URL: http://localhost:$PORT"
            echo "📦 Container: $CONTAINER_NAME"

            # Get container info
            CONTAINER_ID=$(docker ps -q -f name="$CONTAINER_NAME")
            if [ -n "$CONTAINER_ID" ]; then
                echo "🔧 Container Details:"
                docker inspect "$CONTAINER_ID" --format "  Image: {{.Config.Image}}"
                docker inspect "$CONTAINER_ID" --format "  Created: {{.Created}}"
                echo "  Ports: $PORT:8080"
            fi
        elif docker ps -a --format "table {{.Names}}" | grep -q "$CONTAINER_NAME"; then
            echo "⏸️ Status: Stopped (container exists)"
            echo "💡 Start with: webui-helper start"
        else
            echo "❌ Status: Not installed"
            echo "💡 Install with: webui-helper install"
        fi

        echo ""
        echo "🔗 Ollama Connection:"
        if curl -s http://localhost:11434/api/tags >/dev/null 2>&1; then
            echo "✅ Ollama API: Connected (http://localhost:11434)"
            echo "🌐 Container access: host.containers.internal:11434"
        else
            echo "❌ Ollama API: Not responding"
            echo "💡 Start Ollama with: ollama-helper start"
        fi

        echo ""
        echo "🔐 Authentication:"
        echo "✅ Auth disabled (WEBUI_AUTH=False)"
        echo "🔑 Secret key: 1234 (for development)"

        echo ""
        echo "💾 Data Volume:"
        if docker volume ls | grep -q "open-webui"; then
            echo "✅ Volume 'open-webui' exists"
        else
            echo "ℹ️ No data volume found"
        fi
        ;;
    "logs")
        echo "📄 Open WebUI Logs:"
        if docker ps --format "table {{.Names}}" | grep -q "$CONTAINER_NAME"; then
            docker logs "$CONTAINER_NAME" --tail 50 -f
        else
            echo "❌ Container is not running"
        fi
        ;;
    "update")
        echo "🔄 Updating Open WebUI..."
        echo "Pulling latest image..."
        docker pull "$IMAGE_NAME"

        if docker ps --format "table {{.Names}}" | grep -q "$CONTAINER_NAME"; then
            echo "Stopping current container..."
            docker stop "$CONTAINER_NAME"
        fi

        if docker ps -a --format "table {{.Names}}" | grep -q "$CONTAINER_NAME"; then
            echo "Removing old container..."
            docker rm "$CONTAINER_NAME"
        fi

        echo "Starting updated container..."
        $0 start
        echo "✅ Open WebUI updated to latest version"
        ;;
    "install")
        echo "📦 Installing Open WebUI..."
        $0 start
        ;;
    "uninstall")
        echo "🗑️ Uninstalling Open WebUI..."
        read -p "This will remove the container and all data. Continue? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            $0 stop
            if docker ps -a --format "table {{.Names}}" | grep -q "$CONTAINER_NAME"; then
                docker rm "$CONTAINER_NAME"
                echo "✅ Container removed"
            fi
            if docker volume ls | grep -q "open-webui"; then
                docker volume rm open-webui
                echo "✅ Data volume removed"
            fi
            echo "✅ Open WebUI uninstalled"
        else
            echo "Cancelled."
        fi
        ;;
    "open")
        echo "🌐 Opening Open WebUI in browser..."
        if command -v open >/dev/null 2>&1; then
            open "http://localhost:$PORT"
        else
            echo "Open manually: http://localhost:$PORT"
        fi
        ;;
    "help"|*)
        echo "Open WebUI management helper"
        echo ""
        echo "Usage: $0 <action>"
        echo ""
        echo "Container Management:"
        echo "  start               Start Open WebUI container"
        echo "  stop                Stop Open WebUI container"
        echo "  restart             Restart Open WebUI"
        echo "  status              Show detailed status"
        echo "  logs                Show container logs (follow mode)"
        echo ""
        echo "Maintenance:"
        echo "  install             Install/create Open WebUI container"
        echo "  update              Update to latest version"
        echo "  uninstall           Remove container and data"
        echo ""
        echo "Access:"
        echo "  open                Open in default browser"
        echo "  help                Show this help"
        echo ""
        echo "Configuration:"
        echo "  URL: http://localhost:$PORT"
        echo "  Container: $CONTAINER_NAME"
        echo "  Authentication: Disabled (WEBUI_AUTH=False)"
        echo "  Secret Key: 1234 (development)"
        echo "  Host Access: host.containers.internal:host-gateway"
        echo "  Restart Policy: always"
        echo "  Requires: Docker (Colima) and Ollama"
        echo ""
        echo "Examples:"
        echo "  $0 start && $0 open    # Start and open in browser"
        echo "  $0 status              # Check everything"
        echo "  $0 logs                # Monitor logs"
        ;;
esac