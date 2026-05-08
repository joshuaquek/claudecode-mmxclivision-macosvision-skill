#!/bin/bash
#
# ClaudeCode MiniMax Vision + macOS Vision Skill Installer
# ======================================================
# This wizard installs the image analysis skill for Claude Code.
# It works with or without a MiniMax API key (OCR works without it).
#

set -e

# -------- Colors --------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# -------- Paths --------
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills/analyze-image"
HOOKS_DIR="$CLAUDE_DIR/hooks"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

# -------- Helper Functions --------

log() {
    echo -e "${GREEN}[✓]${RESET} $1"
}

warn() {
    echo -e "${YELLOW}[!]${RESET} $1"
}

error() {
    echo -e "${RED}[✗]${RESET} $1" >&2
}

info() {
    echo -e "${BLUE}[i]${RESET} $1"
}

header() {
    echo ""
    echo -e "${CYAN}${BOLD}========================================${RESET}"
    echo -e "${CYAN}${BOLD} $1${RESET}"
    echo -e "${CYAN}${BOLD}========================================${RESET}"
    echo ""
}

prompt() {
    echo -e "${BOLD}$1${RESET}"
    echo -ne "${YELLOW}> ${RESET}"
}

# -------- System Checks --------

check_macos() {
    header "System Check"

    if [[ "$(uname)" != "Darwin" ]]; then
        error "This skill only works on macOS."
        echo "You are running: $(uname -s)"
        exit 1
    fi
    log "macOS detected"

    # Check for required tools
    local missing=()
    for tool in curl file sips mdls qlmanage; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing+=("$tool")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        error "Missing required tools: ${missing[*]}"
        echo "These are built into macOS but something is wrong with your installation."
        exit 1
    fi
    log "All required macOS tools present"
}

# -------- MiniMax Setup --------

setup_minimax() {
    header "MiniMax Vision Setup (Optional)"

    echo "MiniMax Vision provides AI-powered image descriptions."
    echo "Without it, only OCR (text extraction) will work."
    echo ""
    info "You can skip this and add your API key later."
    echo ""

    prompt "Enter your MiniMax API key (or press Enter to skip):"
    read -r api_key

    if [[ -z "$api_key" ]]; then
        warn "Skipping MiniMax setup. OCR will still work."
        return 0
    fi

    info "Installing mmx-cli globally..."
    if command -v mmx-cli >/dev/null 2>&1; then
        log "mmx-cli already installed globally"
    else
        info "Installing mmx-cli via sudo npm install -g mmx-cli..."
        if sudo npm install -g mmx-cli 2>/dev/null; then
            log "mmx-cli installed successfully"
        else
            warn "mmx-cli installation failed. You may need to run:"
            echo "  sudo npm install -g mmx-cli"
        fi
    fi

    info "Configuring mmx-cli with your API key..."
    if mmx-cli config set api-key "$api_key" 2>/dev/null; then
        log "MiniMax API key configured successfully"
    else
        warn "Could not configure mmx-cli. You may need to run:"
        echo "  mmx-cli config set api-key YOUR_API_KEY"
    fi
}

# -------- File Installation --------

install_files() {
    header "Installing Files"

    # Create directories
    info "Creating directories..."
    mkdir -p "$SKILLS_DIR"
    mkdir -p "$HOOKS_DIR"
    log "Directories created"

    # Copy scripts
    info "Copying scripts..."
    cp "$REPO_DIR/scripts/analyze-image.sh" "$SKILLS_DIR/"
    cp "$REPO_DIR/scripts/ocr.swift" "$SKILLS_DIR/"
    chmod +x "$SKILLS_DIR/analyze-image.sh"
    chmod +x "$SKILLS_DIR/ocr.swift"
    log "Scripts installed to ~/.claude/skills/analyze-image/"

    # Copy hook
    info "Copying hook..."
    cp "$REPO_DIR/hooks/analyze-image-on-url.sh" "$HOOKS_DIR/"
    chmod +x "$HOOKS_DIR/analyze-image-on-url.sh"
    log "Hook installed to ~/.claude/hooks/"
}

# -------- Settings Update --------

update_settings() {
    header "Configuring Claude Code"

    if [[ ! -f "$SETTINGS_FILE" ]]; then
        warn "No settings.json found at $SETTINGS_FILE"
        info "Creating new settings file..."
        cat > "$SETTINGS_FILE" << 'EOF'
{
	"hooks": {}
}
EOF
    fi

    # Check if hook is already registered
    if grep -q "analyze-image-on-url.sh" "$SETTINGS_FILE" 2>/dev/null; then
        log "Hook already registered in settings.json"
        return 0
    fi

    info "Adding UserPromptSubmit hook to settings.json..."

    # Use Python to safely update JSON
    python3 << 'PYEOF'
import json
import sys

settings_file = sys.argv[1]
hook_script = sys.argv[2]

with open(settings_file, 'r') as f:
    try:
        settings = json.load(f)
    except json.JSONDecodeError:
        settings = {"hooks": {}}

if 'hooks' not in settings:
    settings['hooks'] = {}

if 'UserPromptSubmit' not in settings['hooks']:
    settings['hooks']['UserPromptSubmit'] = []

# Check if our hook is already there
hook_exists = False
for hook in settings['hooks']['UserPromptSubmit']:
    if isinstance(hook, dict):
        for h in hook.get('hooks', []):
            if h.get('command') == hook_script:
                hook_exists = True
                break

if not hook_exists:
    settings['hooks']['UserPromptSubmit'].append({
        "hooks": [
            {
                "type": "command",
                "command": hook_script
            }
        ]
    })

with open(settings_file, 'w') as f:
    json.dump(settings, f, indent='\t')
    f.write('\n')

print('done')
PYEOF
    "$SETTINGS_FILE" "$HOOKS_DIR/analyze-image-on-url.sh"

    if [[ $? -eq 0 ]]; then
        log "Claude Code settings updated with UserPromptSubmit hook"
    else
        warn "Could not update settings.json automatically."
        info "Please add this to your ~/.claude/settings.json:"
        echo ""
        echo '  "hooks": {'
        echo '    "UserPromptSubmit": [{'
        echo '      "hooks": [{'
        echo '        "type": "command",'
        echo "        \"command\": \"$HOOKS_DIR/analyze-image-on-url.sh\""
        echo '      }]'
        echo '    }]'
        echo '  }'
        echo ""
    fi
}

# -------- Verification --------

verify_installation() {
    header "Verification"

    info "Testing analyze-image.sh..."
    if bash "$SKILLS_DIR/analyze-image.sh" --version >/dev/null 2>&1; then
        log "analyze-image.sh runs successfully"
    else
        # Try running it to see the usage
        if bash "$SKILLS_DIR/analyze-image.sh" 2>&1 | head -1 | grep -q "Usage"; then
            log "analyze-image.sh runs successfully"
        else
            warn "analyze-image.sh may have issues"
        fi
    fi

    info "Checking hook script..."
    if [[ -x "$HOOKS_DIR/analyze-image-on-url.sh" ]]; then
        log "Hook script is executable"
    else
        chmod +x "$HOOKS_DIR/analyze-image-on-url.sh"
    fi

    info "Checking mmx-cli..."
    if [[ -f "$HOME/.mmx/config.json" ]]; then
        log "MiniMax CLI is configured"
    else
        warn "MiniMax CLI not configured (optional)"
    fi

    echo ""
    info "To verify the hook is working:"
    echo "  1. Restart Claude Code"
    echo "  2. Send an image URL, paste/upload an image, or reference a local path"
    echo "  3. The hook will auto-detect and analyze the image"
    echo ""
}

# -------- Main --------

main() {
    echo ""
    echo -e "${CYAN}${BOLD}"
    echo "  ██╗  ██╗ ██████╗ ████████╗ ██████╗ ███╗"
    echo "  ██║ ██╔╝██╔═══██╗╚══██╔══╝██╔═══██╗████╗"
    echo "  █████╔╝ ██║   ██║   ██║   ██║   ██║██╔██╗"
    echo "  ██╔═██╗ ██║   ██║   ██║   ██║   ██║██║  ██╗"
    echo "  ██║  ██╗╚██████╔╝   ██║   ╚██████╔╝██║  ██║"
    echo "  ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚═╝  ╚═╝"
    echo ""
    echo "  ClaudeCode MiniMax Vision + macOS Vision Skill"
    echo -e "${RESET}"
    echo "  Enable image analysis for text-only Claude Code models"
    echo ""

    check_macos
    setup_minimax
    install_files
    update_settings
    verify_installation

    header "Installation Complete!"

    echo "Your image analysis skill is ready!"
    echo ""
    echo "Usage:"
    echo "  • Restart Claude Code"
    echo "  • Send an image URL, paste/upload an image, or use a local path"
    echo "  • The hook auto-detects and analyzes images"
    echo ""
    echo "Documentation: $REPO_DIR/docs/"
    echo ""
}

main "$@"
