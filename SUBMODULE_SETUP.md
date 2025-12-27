# Using cursor-groupthink as a Git Submodule

This guide shows how to use this workflow in another project via git submodule.

## Quick Setup

### 1. Add the Submodule

From your target project root:

```bash
git submodule add https://github.com/your-username/cursor-groupthink.git .cursor-groupthink
git submodule update --init --recursive
```

### 2. Create Symlinks

Create symlinks to the submodule files:

```bash
# From your project root
ln -s .cursor-groupthink/.cursorrules .cursorrules
ln -s .cursor-groupthink/.cursor .cursor-groupthink-ref

# Copy the prompts directory (or symlink if you prefer)
mkdir -p .cursor/prompts
ln -s ../../.cursor-groupthink/.cursor/prompts/peer_review_prompt.md .cursor/prompts/peer_review_prompt.md

# Create archive directory
mkdir -p .cursor/archive
touch .cursor/archive/.gitkeep
```

### 3. Verify

Open Cursor and ask: "What project rules are active?"

You should see **"Peer Review Workflow Rules"**.

---

## Automated Setup Script

Alternatively, use the provided setup script that handles submodules:

```bash
# From your project root
.cursor-groupthink/setup-submodule.sh
```

---

## Updating the Submodule

When the workflow gets updates:

```bash
cd .cursor-groupthink
git pull origin main
cd ..
git add .cursor-groupthink
git commit -m "Update cursor-groupthink submodule"
```

---

## Alternative: Copy on Setup (One-Time)

If you prefer copies instead of symlinks:

```bash
# Run the setup script pointing to the submodule
.cursor-groupthink/setup.sh .
```

This copies files once. You'll need to re-run it to get updates.

---

## File Structure After Setup

```
your-project/
├── .cursorrules                    # symlink → .cursor-groupthink/.cursorrules
├── .cursor/
│   ├── prompts/
│   │   └── peer_review_prompt.md   # symlink → .cursor-groupthink/.cursor/prompts/...
│   └── archive/                    # your project's plans and reviews
└── .cursor-groupthink/             # git submodule
    ├── .cursorrules
    ├── .cursor/
    │   └── prompts/
    └── setup.sh
```

---

## Notes

- **Symlinks** keep you in sync with workflow updates automatically
- **Copies** give you independence but require manual updates
- The `.cursor/archive/` directory is project-specific (not symlinked)
- `.cursor/scratchpad.md` is project-specific (not included in workflow)

