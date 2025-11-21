# AI Tools configuration and aliases

# Get the AI tools dotfiles directory
AI_TOOLS_DOTFILES_DIR="$(dirname "${(%):-%x}")"

# Environment variables for AI tools
export OLLAMA_HOST="127.0.0.1:11434"

# Open WebUI Configuration Notes:
# - Runs on port 3000 (http://localhost:3000)
# - Authentication disabled (WEBUI_AUTH=False) for local development
# - Uses host.containers.internal:host-gateway for Docker networking
# - Secret key set to '1234' for development convenience
# - Always restart policy for persistent availability

# Aliases for AI tools
alias cc='claude-code'
alias ollama-start='$AI_TOOLS_DOTFILES_DIR/helpers/ollama-helper.sh start'
alias ollama-stop='$AI_TOOLS_DOTFILES_DIR/helpers/ollama-helper.sh stop'
alias ollama-status='$AI_TOOLS_DOTFILES_DIR/helpers/ollama-helper.sh status'
alias ollama-models='$AI_TOOLS_DOTFILES_DIR/helpers/ollama-helper.sh models'
alias webui='$AI_TOOLS_DOTFILES_DIR/helpers/webui-helper.sh'
alias webui-start='$AI_TOOLS_DOTFILES_DIR/helpers/webui-helper.sh start'
alias webui-stop='$AI_TOOLS_DOTFILES_DIR/helpers/webui-helper.sh stop'
alias webui-open='$AI_TOOLS_DOTFILES_DIR/helpers/webui-helper.sh open'

# Quick functions for AI development workflow
ai-start() {
    echo "🚀 Starting AI development environment..."

    # Start Ollama service
    $AI_TOOLS_DOTFILES_DIR/helpers/ollama-helper.sh start

    # Start Open WebUI
    $AI_TOOLS_DOTFILES_DIR/helpers/webui-helper.sh start

    echo ""
    echo "✅ AI environment ready!"
    echo "🤖 Ollama API: http://localhost:11434"
    echo "🌐 Open WebUI: http://localhost:3000"
    echo ""
    echo "💡 Quick commands:"
    echo "  cc <file>          # Open file in Claude Code"
    echo "  ollama run llama3.2:3b  # Start chat with model"
    echo "  webui-open         # Open WebUI in browser"
}

ai-stop() {
    echo "⏹️ Stopping AI development environment..."

    # Stop Open WebUI
    $AI_TOOLS_DOTFILES_DIR/helpers/webui-helper.sh stop

    # Stop Ollama service
    $AI_TOOLS_DOTFILES_DIR/helpers/ollama-helper.sh stop

    echo "✅ AI environment stopped"
}

ai-status() {
    echo "📊 AI Development Environment Status"
    echo "====================================="

    # Check Claude Code
    if command -v claude-code >/dev/null 2>&1; then
        echo "✅ Claude Code: $(claude-code --version 2>/dev/null || echo 'installed')"
    else
        echo "❌ Claude Code: Not installed"
    fi

    echo ""

    # Check Ollama
    $AI_TOOLS_DOTFILES_DIR/helpers/ollama-helper.sh status

    echo ""

    # Check Open WebUI
    $AI_TOOLS_DOTFILES_DIR/helpers/webui-helper.sh status
}

# Model management shortcuts
ai-pull() {
    local model="${1:-llama3.2:3b}"
    echo "📥 Downloading AI model: $model"
    $AI_TOOLS_DOTFILES_DIR/helpers/ollama-helper.sh pull "$model"
}

ai-chat() {
    local model="${1:-llama3.2:3b}"
    echo "💬 Starting chat with $model"
    ollama run "$model"
}

# Quick development workflow
ai-dev() {
    echo "🛠️ AI Development Workflow"
    echo "=========================="
    echo ""
    echo "1. Start environment: ai-start"
    echo "2. Check status: ai-status"
    echo "3. Open WebUI: webui-open"
    echo "4. Use Claude Code: cc <file-or-directory>"
    echo "5. Chat with model: ai-chat [model]"
    echo "6. Stop environment: ai-stop"
    echo ""
    echo "Available models:"
    ollama list 2>/dev/null || echo "  Run 'ai-pull' to download models"
}

# Help function
ai-help() {
    echo "AI Tools dotfiles helper commands:"
    echo ""
    echo "Environment Management:"
    echo "  ai-start            - Start Ollama + Open WebUI"
    echo "  ai-stop             - Stop all AI services"
    echo "  ai-status           - Show comprehensive status"
    echo "  ai-dev              - Show development workflow"
    echo ""
    echo "Individual Tools:"
    echo "  cc                  - Claude Code (alias)"
    echo "  ollama-start        - Start Ollama service"
    echo "  ollama-status       - Ollama status"
    echo "  ollama-models       - List/manage models"
    echo "  webui               - Open WebUI management"
    echo "  webui-start         - Start Open WebUI"
    echo "  webui-open          - Open in browser"
    echo ""
    echo "Model Management:"
    echo "  ai-pull [model]     - Download model (default: llama3.2:3b)"
    echo "  ai-chat [model]     - Start interactive chat"
    echo ""
    echo "Examples:"
    echo "  ai-start            # Start everything"
    echo "  cc .                # Open current directory in Claude Code"
    echo "  ai-pull codellama:7b # Download code model"
    echo "  ai-chat codellama:7b # Chat with code model"
    echo "  webui-open          # Open WebUI in browser"
}