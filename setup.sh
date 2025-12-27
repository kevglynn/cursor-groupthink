#!/bin/bash
# Multi-Model Peer Review Workflow Setup
# Usage: ./setup.sh /path/to/target/project
#    or: curl -sL <raw-url> | bash -s /path/to/target/project

set -e

# Get the directory where this script lives (the source repo)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Target project (argument or current directory)
TARGET="${1:-.}"

# Resolve to absolute path
TARGET="$(cd "$TARGET" 2>/dev/null && pwd)" || {
    echo "❌ Target directory does not exist: $1"
    exit 1
}

echo "🚀 Setting up Multi-Model Peer Review Workflow"
echo "   Source: $SCRIPT_DIR"
echo "   Target: $TARGET"
echo ""

# Create .cursor directory structure
mkdir -p "$TARGET/.cursor/archive"
mkdir -p "$TARGET/.cursor/prompts"

# Copy files
cp "$SCRIPT_DIR/.cursorrules" "$TARGET/.cursorrules"
cp "$SCRIPT_DIR/.cursor/prompts/peer_review_prompt.md" "$TARGET/.cursor/prompts/"

# Create empty scratchpad if it doesn't exist
if [ ! -f "$TARGET/.cursor/scratchpad.md" ]; then
    cat > "$TARGET/.cursor/scratchpad.md" << 'EOF'
# Project Scratchpad

## Background and Motivation
<!-- Planner establishes context here -->

## Key Challenges and Analysis
<!-- Technical analysis and considerations -->

## High-level Task Breakdown
<!-- Step-by-step implementation plan with success criteria -->

## Project Status Board
- [ ] Initial task placeholder

## Executor's Feedback or Assistance Requests
<!-- Executor notes blockers, questions, or completion status here -->

## Lessons
<!-- Reusable insights, fixes, and corrections -->
EOF
    echo "✅ Created .cursor/scratchpad.md"
else
    echo "⏭️  Skipped .cursor/scratchpad.md (already exists)"
fi

# Create .gitkeep in archive
touch "$TARGET/.cursor/archive/.gitkeep"

echo "✅ Copied .cursorrules"
echo "✅ Copied .cursor/prompts/peer_review_prompt.md"
echo "✅ Created .cursor/archive/"
echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Open your project in Cursor"
echo "  2. Start a new chat and ask: 'What project rules are active?'"
echo "  3. You should see 'Peer Review Workflow Rules'"
echo ""

