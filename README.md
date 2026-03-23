Fresh Mac Bootstrap

```bash
#1. 安裝 Homebrew（會一併裝 Xcode Command Line Tools）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
```

# 3. 執行 setup

cd ~/dotfiles-setup && bash setup.sh
腳本會自動：

將 repo 轉換為 bare repo 放在 ~/.dotfiles，config 檔案 checkout 到 $HOME
安裝所有 brew 套件、cask 應用、字體
透過 mise 安裝 Node.js、Go、Java、Python
產生 .zshenv、.zprofile、.zshrc（這三個不由 repo 追蹤）
設定 macOS 系統偏好
清理暫存的 clone 目錄

跑完之後的手動設定

重新登入讓鍵盤/觸控板設定生效
p10k configure 設定 Powerlevel10k
登入 1Password → 開啟 SSH Agent
gh auth login、aws configure
System Settings 手動設定：

Keyboard > Shortcuts > Input Sources：輸入法切換改為 ⌘ + Space
Keyboard > Shortcuts > Spotlight：取消 ⌘ + Space
Keyboard > Keyboard Shortcuts > Modifier Keys：Caps Lock → Ctrl
Finder sidebar 加入 Home 資料夾

日常管理 Dotfiles
bash# 查看追蹤狀態
dotfiles status

# 追蹤新檔案

dotfiles add ~/.config/nvim/
dotfiles commit -m "update nvim config"
dotfiles push
Repo 結構
.
├── setup.sh # 一鍵設定腳本
├── README.md # 本文件
├── .config/
│ └── nvim/ # Neovim 設定
│ └── .tmux.conf # tmux 設定
├── .ssh/
│ └── config # SSH config (1Password Agent)
└── .p10k.zsh # Powerlevel10k 設定
