#!/bin/sh
# Prompt Polisher Hook Installer
# One-line install: curl -fsSL https://raw.githubusercontent.com/luckybilly/prompt-polisher/main/hooks/install.sh | sh
#
# What this does:
#   1. Creates ~/.claude/hooks/prompt-polisher-hook.sh
#   2. Makes it executable
#   3. Adds hook config to ~/.claude/settings.json (merges with existing hooks)
#
# Requires: jq (brew install jq / apt install jq)

set -e

HOOK_DIR="$HOME/.claude/hooks"
HOOK_DST="$HOOK_DIR/prompt-polisher-hook.sh"
SETTINGS="$HOME/.claude/settings.json"

# --- Preflight ---

if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is required. Install with:"
    echo "  macOS:  brew install jq"
    echo "  Linux:  apt install jq / yum install jq"
    exit 1
fi

# --- Create hook script ---

mkdir -p "$HOOK_DIR"

cat > "$HOOK_DST" << 'HOOK_EOF'
#!/bin/sh
# Prompt Polisher — Claude Code Hook
# Enforces prompt polishing on every user input via UserPromptSubmit event.
printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"[Prompt Polisher — System Enforcement]\\nBefore responding to ANY user input, you MUST complete these steps IN ORDER:\\n\\n1. UNDERSTAND: Correct typos and abbreviations. Make vague goals concrete. Infer intent from context. Detect ambiguities that change the execution direction.\\n2. SHOW: Display the polished prompt as \\"## Polished Prompt\\" (or \\"## 润色后的提示词\\"). Show corrections, inferences, and ambiguities below it.\\n3. EXECUTE: Only then proceed with the task.\\n\\nNo exceptions — this applies to greetings, single-word inputs, follow-ups, and questions about the framework itself. Skipping the polishing step is a protocol violation."}}'
HOOK_EOF

chmod +x "$HOOK_DST"
echo "✓ Hook script installed to $HOOK_DST"

# --- Configure settings.json ---

if [ ! -f "$SETTINGS" ]; then
    echo '{}' > "$SETTINGS"
    echo "✓ Created $SETTINGS"
fi

HOOK_CMD="sh $HOOK_DST"

# Check if already installed
if jq -e --arg cmd "$HOOK_CMD" \
  '.hooks.UserPromptSubmit // [] | .[] | select(.matcher == "" or .matcher == null) | .hooks[] | select(.command == $cmd)' \
  "$SETTINGS" > /dev/null 2>&1; then
    echo "✓ Hook already configured in settings.json — no changes needed"
else
    cp "$SETTINGS" "$SETTINGS.bak"

    NEW_ENTRY=$(jq -n --arg cmd "$HOOK_CMD" '{
        "matcher": "",
        "hooks": [{
            "type": "command",
            "command": $cmd
        }]
    }')

    jq --argjson entry "$NEW_ENTRY" '
        .hooks //= {} |
        .hooks.UserPromptSubmit //= [] |
        .hooks.UserPromptSubmit += [$entry]
    ' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"

    echo "✓ Added Prompt Polisher hook to settings.json"
    echo "  Backup saved as $SETTINGS.bak"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Prompt Polisher hook installed!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Restart Claude Code to activate."
