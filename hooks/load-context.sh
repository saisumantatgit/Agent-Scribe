#!/bin/bash
# load-context.sh — SessionStart hook for Agent-Scribe
# Loads the most recent logbook Handoff Notes into session context.
# Latency: ~100ms (reads one file, extracts one section)

set -e

INPUT=$(cat)
CWD=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('cwd','.'))" 2>/dev/null || echo ".")

LOGBOOK_DIR="$CWD/docs/logbook"

LATEST=$(ls -t "$LOGBOOK_DIR"/*.md 2>/dev/null | grep -v TEMPLATE | head -1)

if [ -z "$LATEST" ]; then
    exit 0
fi

FILENAME=$(basename "$LATEST")

HANDOFF=$(sed -n '/### Handoff Notes/,/^---$/p' "$LATEST" 2>/dev/null | grep -v '^---$' | grep -v '^### Handoff Notes' | head -20)
BLOCKERS=$(sed -n '/### Blockers/,/^###/p' "$LATEST" 2>/dev/null | grep -v '^###' | head -10)

if [ -n "$HANDOFF" ] || [ -n "$BLOCKERS" ]; then
    CONTEXT="LAST SESSION HANDOFF (from $FILENAME):"
    if [ -n "$HANDOFF" ]; then
        CONTEXT="$CONTEXT\n\nHandoff Notes:\n$HANDOFF"
    fi
    if [ -n "$BLOCKERS" ]; then
        CONTEXT="$CONTEXT\n\nOpen Blockers:\n$BLOCKERS"
    fi

    python3 -c "
import json
context = '''$CONTEXT'''
print(json.dumps({'additionalContext': context}))
" 2>/dev/null
fi

exit 0
