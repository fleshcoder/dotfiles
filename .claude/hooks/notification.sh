#!/bin/bash

# Read JSON input from stdin (Claude Code hook standard)
input=$(cat)
# MESSAGE=$(echo "$input" | jq -r '.message // "No message found"')
MESSAGE=$(gemini -p "請使用不超過20個字進行總結 \"$input\", 並固定以 \"Claude 通知: \" 為開頭")

# Show Mac notifications
osascript -e "display notification \"${MESSAGE}\" with title \"Claude Code\" sound name \"Blow\""
# say "${MESSAGE}"

# Play notification sound twice
afplay "/Users/dida.hsu/.claude/hooks/BotW - Double Sheikah Sensor Ping.m4a" &
sleep 0.5
afplay "/Users/dida.hsu/.claude/hooks/BotW - Double Sheikah Sensor Ping.m4a" &


