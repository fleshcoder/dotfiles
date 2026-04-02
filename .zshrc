# =============================================================================
# .zshrc - loaded for INTERACTIVE shells only
# Prompt, aliases, completions, interactive tools.
# =============================================================================

# --- start new tmux session when terminal up ---- #
if [[ -z "$TMUX" ]] && [[ -n "$GHOSTTY_RESOURCES_DIR" ]]; then
  exec tmux new-session -A -s main
fi

# --- Powerlevel10k instant prompt (must be at very top) ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Oh-My-Zsh ---
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_DISABLE_COMPFIX=true

plugins=(
  git
  docker
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# Powerlevel10k config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# --- History ---
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt HIST_REDUCE_BLANKS
setopt HIST_FIND_NO_DUPS

# --- mise (interactive mode, full activation) ---
eval "$(mise activate zsh)"

# =============================================================================
# Aliases
# =============================================================================

# dotfiles sync
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'


# Git
alias gdft="git dft"


# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Modern replacements
alias ls="eza --icons"
alias ll="eza --icons -la"
alias la="eza --icons -la"
alias lt="eza --icons --tree"
alias cat="bat"
alias find="fd"
alias grep="rg"

# Utilities
alias mkdir="mkdir -p"
alias df="df -h"
alias du="du -h"

# Trash (safe rm)
alias rm="trash"
alias rrm="command rm"
alias tl="ls ~/.Trash"
alias te="empty-trash"

empty-trash() {
  echo "確定要清空垃圾桶？(y/N)"
  read -r ans
  [[ "$ans" =~ ^[Yy]$ ]] && osascript -e 'tell app "Finder" to empty trash'
}

# Editor
alias vim="nvim"
alias vi="nvim"

# Git (beyond oh-my-zsh plugin)
alias glog="git log --oneline --graph --decorate -20"

# Docker
alias d="docker"
alias dc="docker compose"
alias dps="docker ps"

# Lazy shortcuts
alias lg="lazygit"
alias k="kubectl"
alias tf="terraform"
alias top="htop"

# Go
alias gor="go run"
alias gob="go build"
alias got="go test"
alias gov="go vet"
alias gomt="go mod tidy"

# Python
alias python="python3"
alias pip="pip3"

# Quick config editing
alias zshconfig="$EDITOR ~/.zshrc"
alias zshenv="$EDITOR ~/.zshenv"
alias zshprofile="$EDITOR ~/.zprofile"
alias reload="source ~/.zshrc"

# Claude Code
alias cc="claude"
alias ccd="claude --dangerously-skip-permissions"

# =============================================================================
# Interactive Tools (must be after PATH is fully constructed)
# =============================================================================

# Zoxide - smart cd
eval "$(zoxide init zsh)"

# fzf - fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf config
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
