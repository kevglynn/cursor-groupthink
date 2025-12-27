#!/bin/bash
# Multi-Model Peer Review Workflow - Submodule Setup
# Usage: Run from project root after adding cursor-groupthink as submodule
#        .cursor-groupthink/setup-submodule.sh

set -e

# Get the directory where this script lives (the submodule root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Project root (parent of .cursor-groupthink)
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🔗 Setting up Multi-Model Peer Review Workflow (Submodule Mode)"
echo "   Submodule: $SCRIPT_DIR"
echo "   Project: $PROJECT_ROOT"
echo ""

# Check if we're in a submodule directory
if [ ! -f "$SCRIPT_DIR/.cursorrules" ]; then
    echo "❌ Error: This script must be run from the cursor-groupthink submodule directory"
    echo "   Expected: $SCRIPT_DIR/.cursorrules"
    exit 1
fi

# Create .cursor directory structure in project
mkdir -p "$PROJECT_ROOT/.cursor/archive"
mkdir -p "$PROJECT_ROOT/.cursor/prompts"

# Create symlinks
echo "Creating symlinks..."

# .cursorrules symlink
if [ -L "$PROJECT_ROOT/.cursorrules" ]; then
    echo "⏭️  Skipped .cursorrules (symlink already exists)"
elif [ -f "$PROJECT_ROOT/.cursorrules" ]; then
    echo "⚠️  Warning: .cursorrules already exists (not a symlink). Backing up to .cursorrules.backup"
    mv "$PROJECT_ROOT/.cursorrules" "$PROJECT_ROOT/.cursorrules.backup"
    ln -s ".cursor-groupthink/.cursorrules" "$PROJECT_ROOT/.cursorrules"
    echo "✅ Created .cursorrules symlink"
else
    ln -s ".cursor-groupthink/.cursorrules" "$PROJECT_ROOT/.cursorrules"
    echo "✅ Created .cursorrules symlink"
fi

# Prompts symlink
if [ -L "$PROJECT_ROOT/.cursor/prompts/peer_review_prompt.md" ]; then
    echo "⏭️  Skipped .cursor/prompts/peer_review_prompt.md (symlink already exists)"
elif [ -f "$PROJECT_ROOT/.cursor/prompts/peer_review_prompt.md" ]; then
    echo "⚠️  Warning: peer_review_prompt.md already exists. Backing up to peer_review_prompt.md.backup"
    mv "$PROJECT_ROOT/.cursor/prompts/peer_review_prompt.md" "$PROJECT_ROOT/.cursor/prompts/peer_review_prompt.md.backup"
    ln -s "../../.cursor-groupthink/.cursor/prompts/peer_review_prompt.md" "$PROJECT_ROOT/.cursor/prompts/peer_review_prompt.md"
    echo "✅ Created .cursor/prompts/peer_review_prompt.md symlink"
else
    ln -s "../../.cursor-groupthink/.cursor/prompts/peer_review_prompt.md" "$PROJECT_ROOT/.cursor/prompts/peer_review_prompt.md"
    echo "✅ Created .cursor/prompts/peer_review_prompt.md symlink"
fi

# Create .gitkeep in archive if it doesn't exist
if [ ! -f "$PROJECT_ROOT/.cursor/archive/.gitkeep" ]; then
    touch "$PROJECT_ROOT/.cursor/archive/.gitkeep"
    echo "✅ Created .cursor/archive/.gitkeep"
fi

# Create scratchpad if it doesn't exist
if [ ! -f "$PROJECT_ROOT/.cursor/scratchpad.md" ]; then
    cat > "$PROJECT_ROOT/.cursor/scratchpad.md" << 'EOF'
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

echo ""
echo "🎉 Submodule setup complete!"
echo ""
echo "Files linked:"
echo "  • .cursorrules → .cursor-groupthink/.cursorrules"
echo "  • .cursor/prompts/peer_review_prompt.md → .cursor-groupthink/.cursor/prompts/peer_review_prompt.md"
echo ""
echo "Next steps:"
echo "  1. Open your project in Cursor"
echo "  2. Start a new chat and ask: 'What project rules are active?'"
echo "  3. You should see 'Peer Review Workflow Rules'"
echo ""
echo "To update the workflow:"
echo "  cd .cursor-groupthink && git pull && cd .."
echo ""

