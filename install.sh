#!/bin/bash
# Agent-Scribe Installer
# Detects your CLI tool and installs the right adapter.

set -e

echo "🖋️  Agent-Scribe Installer"
echo "========================="
echo ""

# Detect CLI tool
if [ -d ".claude" ]; then
    CLI="claude-code"
    echo "Detected: Claude Code"
elif [ -d ".cursor" ]; then
    CLI="cursor"
    echo "Detected: Cursor"
elif [ -f ".aider.conf.yml" ]; then
    CLI="aider"
    echo "Detected: Aider"
elif [ -f "AGENTS.md" ]; then
    CLI="codex"
    echo "Detected: Codex"
else
    CLI="generic"
    echo "No specific CLI detected — installing generic prompts"
fi

echo ""
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Copy core prompts and templates
echo "Installing prompts..."
cp -r "$SCRIPT_DIR/prompts" .
echo "Installing templates..."
cp -r "$SCRIPT_DIR/templates" .

# Create docs directories
echo "Creating docs structure..."
mkdir -p docs/aar docs/pir docs/logbook docs/adr

# Copy templates into docs
cp "$SCRIPT_DIR/templates/aar-template.md" docs/aar/TEMPLATE.md
cp "$SCRIPT_DIR/templates/pir-template.md" docs/pir/TEMPLATE.md
cp "$SCRIPT_DIR/templates/logbook-template.md" docs/logbook/TEMPLATE.md
cp "$SCRIPT_DIR/templates/adr-template-madr-v4.md" docs/adr/TEMPLATE.md

# Install CLI-specific adapter
echo "Installing $CLI adapter..."
case $CLI in
    claude-code)
        mkdir -p .claude/commands
        cp "$SCRIPT_DIR/adapters/claude-code/commands/"*.md .claude/commands/
        cp "$SCRIPT_DIR/hooks/load-context.sh" .
        chmod +x load-context.sh
        echo ""
        echo "Hook setup: Add this to your .claude/settings.json:"
        echo '  "hooks": { "SessionStart": [{ "command": "bash load-context.sh" }] }'
        ;;
    codex)
        if [ -f "AGENTS.md" ]; then
            echo "" >> AGENTS.md
            cat "$SCRIPT_DIR/adapters/codex/AGENTS.md" >> AGENTS.md
            echo "Appended governance commands to existing AGENTS.md"
        else
            cp "$SCRIPT_DIR/adapters/codex/AGENTS.md" .
        fi
        ;;
    cursor)
        mkdir -p .cursor/rules
        cp "$SCRIPT_DIR/adapters/cursor/.cursor/rules/governance.md" .cursor/rules/
        ;;
    aider)
        if [ -f ".aider.conf.yml" ]; then
            echo "# Agent-Scribe additions:" >> .aider.conf.yml
            cat "$SCRIPT_DIR/adapters/aider/.aider.conf.yml" >> .aider.conf.yml
            echo "Appended to existing .aider.conf.yml"
        else
            cp "$SCRIPT_DIR/adapters/aider/.aider.conf.yml" .
        fi
        ;;
    generic)
        echo "Prompts and templates installed. See prompts/README.md for usage."
        ;;
esac

echo ""
echo "✅ Agent-Scribe installed for $CLI"
echo ""
echo "Commands available:"
echo "  /logbook    — Write session logbook entry"
echo "  /draft-aar  — After Action Review"
echo "  /draft-pir  — Post-Incident Review"
echo "  /draft-adr  — Architecture Decision Record"
echo ""
echo "Session-start hook loads last session's handoff notes automatically."
