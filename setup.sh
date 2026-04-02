#!/bin/bash
set -e

echo "========================================="
echo "  Mac Setup Script - Dida's Dev Environment"
echo "========================================="

DOTFILES_DIR="$HOME/.dotfiles"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# -------------------------------------------
# 1. Homebrew
# -------------------------------------------
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Updating Homebrew..."
brew update

# -------------------------------------------
# 2. Git
# -------------------------------------------
echo "Installing & configuring Git..."
brew install git
brew install git-extras
brew install gh

# -------------------------------------------
# 3. Dotfiles (convert to bare repo)
# -------------------------------------------
echo "Setting up dotfiles bare repo..."
 
dotfiles() {
  git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}
 
if [ ! -d "$DOTFILES_DIR" ]; then
  # 從目前 clone 下來的 repo 轉換成 bare repo
  git clone --bare "$SCRIPT_DIR" "$DOTFILES_DIR"
 
  # 設定 remote 指向 GitHub（取代本地路徑）
  dotfiles remote set-url origin git@github.com:fleshcoder/dotfiles.git
 
  dotfiles config --local status.showUntrackedFiles no
 
  # checkout dotfiles 到 $HOME，衝突檔案先備份
  if ! dotfiles checkout 2>/dev/null; then
    echo "Backing up conflicting dotfiles..."
    mkdir -p "$HOME/.dotfiles-backup"
    dotfiles checkout 2>&1 \
      | grep -E "^\s+" \
      | awk '{print $1}' \
      | while read -r file; do
          mkdir -p "$HOME/.dotfiles-backup/$(dirname "$file")"
          mv "$HOME/$file" "$HOME/.dotfiles-backup/$file"
        done
    dotfiles checkout
  fi
 
  echo "Dotfiles restored to \$HOME."
else
  echo "Dotfiles bare repo already exists, skipping."
fi

# -------------------------------------------
# 4. Zsh & Terminal
# -------------------------------------------
echo "Installing terminal tools..."
brew install zsh
brew install tmux
brew install neovim

# Tmux plugins
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm 2>/dev/null || true
export TMUX_PLUGIN_MANAGER_PATH="$HOME/.config/tmux/plugins"
~/.config/tmux/plugins/tpm/bin/install_plugins

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# Zsh plugins
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
fi

if [ ! -d "$HOME/.config/tmux/plugins/catppuccin/tmux" ]; then
  git clone -b v2.1.3 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
fi

# -------------------------------------------
# 5. Modern CLI Tools
# -------------------------------------------
echo "Installing modern CLI tools..."
cli_tools=(
  fzf
  ripgrep
  fd
  zoxide
  eza
  bat
  jq
  htop
  wget
  trash
  lazygit
	difftastic 
	delta
)

brew install "${cli_tools[@]}"

# fzf key bindings & completion
if [ ! -f "$HOME/.fzf.zsh" ]; then
  "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

# -------------------------------------------
# 6. Runtime Version Manager (mise)
# -------------------------------------------

echo "Installing mise for runtime management..."
brew install mise

# -------------------------------------------
# 7. Languages & SDKs (brew-managed, not runtime)
# -------------------------------------------
echo "Installing language tooling..."
brew install protobuf
brew install golangci-lint

# Rust (via rustup, not brew) — must be before cargo usage
if ! command -v rustup &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# -------------------------------------------
# 8. Neovim Ecosystem
# -------------------------------------------
echo "Installing Neovim dependencies..."
cargo install --locked tree-sitter-cli
neovim_deps=(
  lua-language-server
  stylua
  tree-sitter
)
brew install "${neovim_deps[@]}"

# -------------------------------------------
# 9. Infrastructure & DevOps
# -------------------------------------------
echo "Installing infra tools..."
brew install kubectl
brew install terraform
brew install awscli

# -------------------------------------------
# 10. Fonts
# -------------------------------------------
echo "Installing fonts..."

# English monospace (terminal & editor)
eng_fonts=(
  font-fira-code
  font-jetbrains-mono-nerd-font
  font-inconsolata-nerd-font
  font-maple-mono-nf              # 圓潤現代，內建中文搭配
  font-monaspace                   # GitHub 出品，texture healing
  font-monaspice-nerd-font         # Monaspace 的 Nerd Font 版本
)
for font in "${eng_fonts[@]}"; do
  brew install --cask "$font" || echo "Warning: Failed to install $font, skipping..."
done

# Chinese fonts (terminal CJK fallback & reading)
cjk_fonts=(
  font-lxgw-wenkai-tc              # 霞鶩文楷 TC（繁體）
  font-lxgw-wenkai-mono-tc         # 霞鶩文楷等寬 TC（終端用）
  font-sarasa-gothic               # 更紗黑體（中英等寬混排最佳）
)
for font in "${cjk_fonts[@]}"; do
  brew install --cask "$font" || echo "Warning: Failed to install $font, skipping..."
done

# -------------------------------------------
# 11. GUI Applications
# -------------------------------------------
echo "Installing applications..."
apps=(
  1password
  google-chrome
  arc
  jetbrains-toolbox
  visual-studio-code
  docker
  android-studio
  notion
  heptabase
  slack
  discord
  telegram
	orbstack
  spotify
  raycast
  appcleaner
  the-unarchiver
	ghostty
	claude
	claude-code
	iina
	obs
	hiddenbar
	input-source-pro
)
for app in "${apps[@]}"; do
  brew install --cask "$app" || echo "Warning: Failed to install $app, skipping..."
done

# -------------------------------------------
# 12. Mac App Store Apps
# -------------------------------------------
echo "Installing Mac App Store apps..."
brew install mas
mas install 539883307 || echo "Warning: Failed to install LINE from App Store (not logged in?), skipping..."

# -------------------------------------------
# 13. SSH config (1Password SSH Agent)
# -------------------------------------------
echo "Configuring SSH for 1Password Agent..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [ ! -f "$HOME/.ssh/config" ]; then
  cat > "$HOME/.ssh/config" << 'SSHCONFIG_EOF'
Host *
  IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
SSHCONFIG_EOF
  chmod 600 "$HOME/.ssh/config"
fi

# -------------------------------------------
# 14. Runtime Versions (via mise)
# -------------------------------------------
echo "Installing runtime versions via mise..."
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(mise activate bash)"
mise use --global node@lts
mise use --global go@latest
mise use --global java@temurin-21
mise use --global python@3


# -------------------------------------------
# 15. macOS System Preferences
# -------------------------------------------
echo "Configuring macOS preferences..."

# --- Keyboard ---
# 1. F1~F12 作為標準功能鍵（需重新登入生效）
defaults write -g com.apple.keyboard.fnState -bool true

# 8. 關閉自動大寫
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# --- Siri ---
# 7. 停用 Siri
defaults write com.apple.assistant.support "Assistant Enabled" -bool false
defaults write com.apple.Siri StatusMenuVisible -bool false

# --- Trackpad ---
# 5. 三指拖移
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# --- Battery ---
# 9. 電池顯示百分比
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true

# --- Finder ---
chflags nohidden ~/Library
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
killall Finder 2>/dev/null || true

# --- Dock ---
defaults delete com.apple.dock persistent-apps 2>/dev/null || true
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock show-recents -bool false
killall Dock 2>/dev/null || true

# -------------------------------------------
# 16. Cleanup
# -------------------------------------------
echo "Cleaning up..."
brew cleanup

echo "========================================="
echo "  Setup Finished!"
echo "========================================="
echo ""
echo "NEXT STEPS:"
echo "  1. 重新登入讓鍵盤/觸控板設定生效"
echo "  2. Run: p10k configure"
echo "  3. 安裝 嘸蝦咪輸入法"
echo "  4. Restore Neovim config to ~/.config/nvim/"
echo "  5. Login: 1Password, Chrome, Slack, gh auth login"
echo "  6. Configure AWS: aws configure"
echo "  7. Import SSH/GPG keys from backup"
echo "  8. 手動設定: System Settings > Keyboard > Shortcuts"
echo "     - Input Sources: 輸入法切換改為 Command + Space"
echo "     - Spotlight: 取消 Command + Space（改用 Raycast）"
echo "  9. 手動設定: Finder sidebar 加入 Home 資料夾"
echo " 10. 手動設定: Caps Lock 改為 Ctrl"
echo "     System Settings > Keyboard > Keyboard Shortcuts > Modifier Keys"
echo ""
