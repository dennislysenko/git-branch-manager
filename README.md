# git-branch-manager

Interactive helper to review and clean up local Git branches with protect/skip/delete actions.

## Install

```bash
# Clone
git clone https://github.com/your-username/git-branch-manager.git ~/dev/git-branch-manager

# Add to PATH (recommended per-user bin)
mkdir -p ~/.local/bin
ln -sf ~/dev/git-branch-manager/bin/git-branch-manager ~/.local/bin/git-branch-manager

# Ensure ~/.local/bin is on your PATH (for zsh)
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
  source ~/.zshrc
fi

# Test
which git-branch-manager
git-branch-manager
```

## Usage
Run from inside any Git repo:

```bash
git-branch-manager
```

- s: skip
- p: protect branch (writes to `.gitprotectedbranches`)
- d: delete (safe)
- D: force delete
- q: quit
