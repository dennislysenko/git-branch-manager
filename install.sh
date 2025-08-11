#!/usr/bin/env sh
set -e

REPO_URL="https://github.com/dennislysenko/git-branch-manager.git"
DEST_DIR="$HOME/dev/git-branch-manager"
USER_BIN="$HOME/.local/bin"
BIN_NAME="git-branch-manager"

# Detect user's login shell (prefer $SHELL, fall back to version vars)
DETECTED_SHELL="$(basename "${SHELL:-}")"
if [ "$DETECTED_SHELL" = "" ]; then
  if [ -n "$ZSH_VERSION" ]; then
    DETECTED_SHELL="zsh"
  elif [ -n "$BASH_VERSION" ]; then
    DETECTED_SHELL="bash"
  fi
fi

# Choose profile file based on detected shell
PROFILE_FILE=""
if [ "$DETECTED_SHELL" = "zsh" ]; then
  PROFILE_FILE="$HOME/.zshrc"
elif [ "$DETECTED_SHELL" = "bash" ]; then
  if [ -f "$HOME/.bash_profile" ]; then
    PROFILE_FILE="$HOME/.bash_profile"
  else
    PROFILE_FILE="$HOME/.bashrc"
  fi
else
  # default to zsh if present else bash rc
  if command -v zsh >/dev/null 2>&1; then
    PROFILE_FILE="$HOME/.zshrc"
  else
    if [ -f "$HOME/.bash_profile" ]; then
      PROFILE_FILE="$HOME/.bash_profile"
    else
      PROFILE_FILE="$HOME/.bashrc"
    fi
  fi
fi

printf "\nInstalling %s...\n" "$BIN_NAME"

# Ensure directories exist
mkdir -p "$HOME/dev"
mkdir -p "$USER_BIN"

# Clone or update repo
if [ -d "$DEST_DIR/.git" ]; then
  printf "Repo already exists at %s, updating...\n" "$DEST_DIR"
  git -C "$DEST_DIR" pull --ff-only || true
else
  printf "Cloning into %s...\n" "$DEST_DIR"
  git clone "$REPO_URL" "$DEST_DIR"
fi

# Symlink binary into user bin
ln -sf "$DEST_DIR/bin/$BIN_NAME" "$USER_BIN/$BIN_NAME"

# Ensure user bin is on PATH via profile
if ! printf "%s" "$PATH" | grep -q "$USER_BIN"; then
  printf "Adding %s to PATH in %s...\n" "$USER_BIN" "$PROFILE_FILE"
  # Create profile file if missing
  touch "$PROFILE_FILE"
  # Append export only if not already present
  if ! grep -qs "^export PATH=\"$USER_BIN:\$PATH\"" "$PROFILE_FILE"; then
    {
      printf "\n# Added by git-branch-manager installer on $(date)\n"
      printf "export PATH=\"%s:\$PATH\"\n" "$USER_BIN"
    } >> "$PROFILE_FILE"
  fi
  printf "\nPlease reload your shell or run:\n    source %s\n\n" "$PROFILE_FILE"
fi

# Final check
if command -v "$BIN_NAME" >/dev/null 2>&1; then
  printf "Installation complete. Try: %s\n" "$BIN_NAME"
else
  printf "Installation complete, but %s not yet on PATH in this session.\n" "$BIN_NAME"
  printf "You may need to 'source %s' or start a new shell.\n" "$PROFILE_FILE"
fi
