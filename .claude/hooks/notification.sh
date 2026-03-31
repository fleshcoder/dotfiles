#!/usr/bin/env bash
# =============================================================================
# Claude Code Hook 通知腳本
#
# 安裝:
#   mkdir -p ~/.claude/scripts
#   cp notify.sh ~/.claude/scripts/notify.sh
#   chmod +x ~/.claude/scripts/notify.sh
#
# 用法（由 Claude Code hooks 自動呼叫）:
#   notify.sh finished     → Claude 完成任務
#   notify.sh attention    → Claude 等待你的輸入
# =============================================================================

set -euo pipefail

EVENT_TYPE="${1:-finished}"

# 從 stdin 讀取 Claude Code 傳入的 JSON
INPUT=$(cat)

# 取得專案目錄名稱（作為辨識用）
PROJECT_NAME=$(basename "$(pwd)")

# 取得 tmux session 名稱（如果在 tmux 裡）
TMUX_SESSION=""
if [[ -n "${TMUX:-}" ]]; then
  TMUX_SESSION=$(tmux display-message -p '#S')
fi

# 根據事件類型設定通知內容
case "$EVENT_TYPE" in
  finished)
    ICON="✅"
    TITLE="$ICON $PROJECT_NAME 完成了"
    MESSAGE="Claude Code 已完成任務"
    SOUND="Hero"
    ;;
  attention)
    ICON="⚠️"
    TITLE="$ICON $PROJECT_NAME 需要你的注意"
    # 從 hook input 取得 Claude 的通知訊息
    HOOK_MSG=$(echo "$INPUT" | jq -r '.message // empty' 2>/dev/null || true)
    MESSAGE="${HOOK_MSG:-Claude Code 需要你的輸入}"
    SOUND="Glass"
    ;;
  *)
    ICON="💬"
    TITLE="$ICON $PROJECT_NAME"
    MESSAGE="Claude Code 事件: $EVENT_TYPE"
    SOUND="Ping"
    ;;
esac

# 加上 tmux session 名稱到標題
if [[ -n "$TMUX_SESSION" ]]; then
  TITLE="$TITLE [$TMUX_SESSION]"
fi

# --- 通知管道 ---

# 1) tmux 訊息（在 status bar 顯示，任何 session 都看得到）
if [[ -n "${TMUX:-}" ]]; then
  tmux display-message -d 5000 "$TITLE — $MESSAGE" 2>/dev/null || true
fi

# 2) Terminal bell（觸發 tmux 的 monitor-bell 高亮）
echo -e '\a'

# 3) macOS 系統通知 + 音效
if command -v osascript &>/dev/null; then
  osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"$SOUND\"" 2>/dev/null || true
fi


# Play notification sound twice
afplay "/Users/dida.hsu/.claude/hooks/BotW - Double Sheikah Sensor Ping.m4a" &
sleep 0.5
afplay "/Users/dida.hsu/.claude/hooks/BotW - Double Sheikah Sensor Ping.m4a" &

