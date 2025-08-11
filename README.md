# git-branch-manager

Interactive TUI to review and clean up local Git branches with protect/skip/delete actions. Stores protected branches in `.gitprotectedbranches` inside each repo.

## Install

One-line installer (creates `~/dev` if needed, detects bash/zsh, updates PATH, symlinks command):

```bash
curl -fsSL https://raw.githubusercontent.com/dennislysenko/git-branch-manager/main/install.sh | sh
```

Or manual:

```bash
# Clone
git clone https://github.com/dennislysenko/git-branch-manager.git ~/dev/git-branch-manager

# Link to your per-user bin and ensure PATH
mkdir -p ~/.local/bin
ln -sf ~/dev/git-branch-manager/bin/git-branch-manager ~/.local/bin/git-branch-manager

# Ensure ~/.local/bin is on PATH (bash or zsh)
if [ -n "$ZSH_VERSION" ]; then PROFILE="$HOME/.zshrc"; fi
if [ -n "$BASH_VERSION" ]; then PROFILE="${PROFILE:-$HOME/.bash_profile}"; fi
PROFILE="${PROFILE:-$HOME/.zshrc}"
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$PROFILE"
  . "$PROFILE"
fi

# Verify
which git-branch-manager
```

## Usage
Run inside any Git repo:

```bash
git-branch-manager
```

Keys: `s` skip, `p` protect, `d` delete, `D` force delete, `q` quit, `?` help.
