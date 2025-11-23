#!/usr/bin/env bash
#
# AI Tools
#
# This installs and configures AI development tools:
# - Claude Code (AI coding assistant)
# - Ollama (Local LLM runtime)
# - Open WebUI (Web interface for LLMs via Docker)

set -e

source "$(dirname "$0")/../helper.sh"

info "Setting up AI development tools..."

# Check if Claude Code is installed
if command -v claude-code >/dev/null 2>&1; then
    success "Claude Code is already installed"
else
    info "Claude Code will be installed via Homebrew"
fi

# Check if Ollama is installed
if command -v ollama >/dev/null 2>&1; then
    success "Ollama is already installed"
else
    info "Ollama will be installed via Homebrew"
fi

# Check if Docker is available for Open WebUI
if ! docker info >/dev/null 2>&1; then
    fail "Docker is not running. Open WebUI requires Docker. Please start Colima first."
    exit 1
fi

# Set up Ollama configuration directory
OLLAMA_CONFIG_DIR="$HOME/.ollama"
if [ ! -d "$OLLAMA_CONFIG_DIR" ]; then
    mkdir -p "$OLLAMA_CONFIG_DIR"
    info "Created Ollama configuration directory"
fi

# Start Ollama service if not running (after Homebrew installation)
if command -v ollama >/dev/null 2>&1; then
    if ! pgrep -f "ollama serve" >/dev/null; then
        info "Starting Ollama service..."
        ollama serve &
        sleep 3
        success "Ollama service started"
    else
        success "Ollama service is already running"
    fi

    # Install a default model if none exists
    if ! ollama list | grep -q "llama"; then
        info "Installing default LLM model (llama3.2:3b)..."
        ollama pull llama3.2:3b
        success "Default model installed"
    fi
fi

# Set up Open WebUI via Docker
OPEN_WEBUI_CONTAINER="open-webui"
if docker ps -a --format "table {{.Names}}" | grep -q "$OPEN_WEBUI_CONTAINER"; then
    success "Open WebUI container already exists"
else
    info "Setting up Open WebUI via Docker..."
    docker run -d \
        --name "$OPEN_WEBUI_CONTAINER" \
        -p 3000:8080 \
        --add-host=host.containers.internal:host-gateway \
        -e WEBUI_AUTH=False \
        -e WEBUI_SECRET_KEY=1234 \
        -v open-webui:/app/backend/data \
        --restart always \
        ghcr.io/open-webui/open-webui:main

    success "Open WebUI container created and started"
    info "Open WebUI will be available at http://localhost:3000"
    info "Authentication is disabled for easier local development"
fi

# Make helper scripts executable
chmod +x "$(dirname "$0")/helpers/"*.sh 2>/dev/null || true

success "AI tools setup completed!"
echo ""
info "Next steps:"
echo "  1. Claude Code: Run 'claude-code --help' for usage"
echo "  2. Ollama: Run 'ollama list' to see installed models"
echo "  3. Open WebUI: Visit http://localhost:3000 in your browser"

exit 0