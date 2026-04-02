# =============================================================================
# .zshenv - loaded for ALL zsh sessions (interactive & non-interactive)
# Keep this minimal. Only truly universal env vars belong here.
# =============================================================================

# Oh-My-Zsh path
export ZSH="$HOME/.oh-my-zsh"

# Default editor
export EDITOR="nvim"
export VISUAL="nvim"

# Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# XDG Base Directories (keep dotfile clutter under control)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Android SDK (needed by non-interactive builds too)
export ANDROID_HOME="$HOME/Library/Android/sdk"
