
#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract session_id and transcript_path from JSON
session_id=$(echo "$input" | jq -r '.session_id // "未知會話"')
transcript_path=$(echo "$input" | jq -r '.transcript_path // ""')

# Extract directory name from transcript path to identify conversation
if [[ -n "$transcript_path" ]]; then
    conversation_name=$(basename "$(dirname "$transcript_path")")
else
    conversation_name="未知專案"
fi

# Create notification message with conversation info (shortened for better display)
notification_msg="任務完成 | 會話: ${session_id:0:8}... | 專案: $conversation_name"

# Show Mac notifications using native osascript
osascript -e "display notification \"$notification_msg\" with title \"Claude Code\""

# Play completion sound
afplay "/Users/dida.hsu/.claude/hooks/BotW - Item.flac" &
