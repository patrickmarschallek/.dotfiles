#!/usr/bin/env bash
#
# Ollama management helper
#

set -e

ACTION="${1:-help}"

case "$ACTION" in
    "start")
        echo "🚀 Starting Ollama service..."
        if pgrep -f "ollama serve" >/dev/null; then
            echo "✅ Ollama service is already running"
        else
            ollama serve &
            sleep 3
            echo "✅ Ollama service started"
        fi
        ;;
    "stop")
        echo "⏹️ Stopping Ollama service..."
        pkill -f "ollama serve" || echo "Service was not running"
        echo "✅ Ollama service stopped"
        ;;
    "status")
        echo "📊 Ollama Status"
        echo "=================="

        if pgrep -f "ollama serve" >/dev/null; then
            echo "✅ Service: Running"
            echo "🌐 API: http://localhost:11434"
        else
            echo "❌ Service: Not running"
        fi

        echo ""
        echo "📚 Installed Models:"
        if command -v ollama >/dev/null 2>&1; then
            ollama list || echo "No models installed"
        else
            echo "Ollama not installed"
        fi

        echo ""
        echo "💾 Storage location: ~/.ollama"
        if [ -d "$HOME/.ollama" ]; then
            echo "📁 Config directory size: $(du -sh "$HOME/.ollama" 2>/dev/null | cut -f1 || echo "unknown")"
        fi
        ;;
    "models")
        echo "📚 Available Models"
        echo "==================="
        if command -v ollama >/dev/null 2>&1; then
            echo "Installed models:"
            ollama list
            echo ""
            echo "💡 Popular models to try:"
            echo "  ollama pull llama3.2:3b      # Fast, efficient model"
            echo "  ollama pull llama3.2:1b      # Ultra-fast, minimal model"
            echo "  ollama pull codellama:7b     # Code-focused model"
            echo "  ollama pull mistral:7b       # Alternative general model"
        else
            echo "❌ Ollama not installed"
        fi
        ;;
    "pull")
        MODEL="${2:-llama3.2:3b}"
        echo "📥 Downloading model: $MODEL"
        ollama pull "$MODEL"
        echo "✅ Model $MODEL downloaded"
        ;;
    "remove")
        MODEL="${2}"
        if [ -z "$MODEL" ]; then
            echo "Usage: $0 remove <model-name>"
            echo "Available models:"
            ollama list 2>/dev/null || echo "No models installed"
            exit 1
        fi
        echo "🗑️ Removing model: $MODEL"
        ollama rm "$MODEL"
        echo "✅ Model $MODEL removed"
        ;;
    "chat")
        MODEL="${2:-llama3.2:3b}"
        echo "💬 Starting chat with $MODEL (type /bye to exit)"
        ollama run "$MODEL"
        ;;
    "serve-info")
        echo "🔧 Ollama Service Information"
        echo "=============================="
        echo "Default port: 11434"
        echo "API endpoint: http://localhost:11434"
        echo "Health check: http://localhost:11434/api/tags"
        echo ""
        echo "Environment variables:"
        echo "  OLLAMA_HOST=0.0.0.0:11434    # Listen on all interfaces"
        echo "  OLLAMA_MODELS=~/.ollama/models # Model storage location"
        echo ""
        if command -v curl >/dev/null 2>&1; then
            echo "Testing API connection..."
            if curl -s http://localhost:11434/api/tags >/dev/null; then
                echo "✅ API is responding"
            else
                echo "❌ API is not responding"
            fi
        fi
        ;;
    "help"|*)
        echo "Ollama management helper"
        echo ""
        echo "Usage: $0 <action> [args...]"
        echo ""
        echo "Service Management:"
        echo "  start               Start Ollama service"
        echo "  stop                Stop Ollama service"
        echo "  status              Show service and model status"
        echo "  serve-info          Show service configuration info"
        echo ""
        echo "Model Management:"
        echo "  models              List installed models and suggestions"
        echo "  pull <model>        Download a model (default: llama3.2:3b)"
        echo "  remove <model>      Remove an installed model"
        echo ""
        echo "Usage:"
        echo "  chat [model]        Start interactive chat (default: llama3.2:3b)"
        echo "  help                Show this help"
        echo ""
        echo "Examples:"
        echo "  $0 start            # Start service"
        echo "  $0 pull llama3.2:1b # Download fast model"
        echo "  $0 chat codellama:7b # Chat with code model"
        echo "  $0 status           # Check everything"
        ;;
esac