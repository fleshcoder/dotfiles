# =============================================================================
# .zprofile - loaded once for LOGIN shells
# PATH construction & heavyweight tool init belong here.
# =============================================================================

# --- Homebrew (must be first) ---
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- mise (manages node, go, java, python, etc.) ---
eval "$(mise activate zsh --shims)"

# --- Rust / Cargo ---
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# --- Go binaries ---
if command -v go >/dev/null 2>&1; then
  export PATH="$(go env GOPATH)/bin:$PATH"
fi

# --- Android SDK ---
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# --- JetBrains Toolbox CLI ---
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# --- pipx / user-local binaries ---
export PATH="$PATH:$HOME/.local/bin"

# --- Ruby (Homebrew) ---
if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
  GEM_DIR="$(gem environment gemdir 2>/dev/null)"
  [ -n "$GEM_DIR" ] && export PATH="$GEM_DIR/bin:$PATH"
fi
