# Dida's Dotfiles

新 Mac 一鍵設定腳本，支援重複執行（中斷後可直接重跑）。

## Fresh Mac Bootstrap

```bash
# 1. 安裝 Xcode Command Line Tools
xcode-select --install

# 2. Clone repo
git clone https://github.com/fleshcoder/dotfiles.git ~/dotfiles-setup

# 3. 執行 setup
cd ~/dotfiles-setup && bash setup.sh
```

## 腳本會自動完成

- 安裝 Homebrew
- 將 repo 轉換為 bare repo 放在 `~/.dotfiles`，config 檔案 checkout 到 `$HOME`
- 安裝所有 brew 套件、cask 應用、字體
- 設定 tmux（TPM + plugins）、Oh My Zsh、Powerlevel10k
- 安裝 Rust toolchain
- 透過 mise 安裝 Node.js、Go、Java、Python
- 產生 `.zshenv`、`.zprofile`、`.zshrc`（這三個不由 repo 追蹤，由腳本生成）
- 設定 SSH（1Password Agent）
- 設定 macOS 系統偏好（鍵盤、Dock、Finder 等）

## 跑完之後的手動設定

1. 重新登入讓鍵盤/觸控板設定生效
2. `p10k configure` 設定 Powerlevel10k
3. 安裝嘸蝦咪輸入法
4. 登入 1Password → 開啟 SSH Agent
5. `gh auth login`、`aws configure`
6. System Settings 手動設定：
   - Keyboard > Shortcuts > Input Sources：輸入法切換改為 ⌘ + Space
   - Keyboard > Shortcuts > Spotlight：取消 ⌘ + Space
   - Keyboard > Keyboard Shortcuts > Modifier Keys：Caps Lock → Ctrl
   - Finder sidebar 加入 Home 資料夾

## 日常管理 Dotfiles

```bash
# 查看追蹤狀態
dotfiles status

# 追蹤新檔案
dotfiles add ~/.config/nvim/
dotfiles commit -m "update nvim config"
dotfiles push
```

## Repo 結構

```
.
├── setup.sh                        # 一鍵設定腳本
├── README.md
├── .gitconfig                      # Git 設定（delta、difftastic、GPG signing）
├── .config/
│   ├── ghostty/config              # Ghostty 終端設定
│   ├── lazygit/config.yml          # Lazygit 設定
│   ├── mise/config.toml            # mise 全域設定
│   ├── nvim/                       # Neovim 設定（Lazy.nvim）
│   └── tmux/tmux.conf              # tmux 設定（TPM + Catppuccin）
└── .local/
    └── bin/tmux-sessionizer        # tmux session 快速切換腳本
```
