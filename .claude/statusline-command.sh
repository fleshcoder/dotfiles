#!/usr/bin/env bash
# Claude Code status line - inspired by Powerlevel10k classic theme
# Shows: user@host  dir  git branch  |  model  context%  5h:X% 7d:X%

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Shorten home directory to ~
home="$HOME"
short_dir="${cwd/#$home/~}"

# Git repo name + branch (skip optional locks)
git_info=""
if git_out=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null); then
  repo_root=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
  repo_name=$(basename "$repo_root")
  git_info="$repo_name/$git_out"
fi

# Context usage progress bar
ctx=""
if [ -n "$used_pct" ]; then
  bar_width=10
  filled=$(printf '%.0f' "$(echo "$used_pct * $bar_width / 100" | bc -l)")
  empty=$((bar_width - filled))
  bar=""
  for ((i=0; i<filled; i++)); do bar+="█"; done
  for ((i=0; i<empty; i++)); do bar+="░"; done
  pct_int=$(printf '%.0f' "$used_pct")
  # Color: green <50, yellow <80, red >=80
  if [ "$pct_int" -ge 80 ]; then
    color="31"  # red
  elif [ "$pct_int" -ge 50 ]; then
    color="33"  # yellow
  else
    color="32"  # green
  fi
  ctx=$(printf '\033[%smctx %s\033[0m \033[%sm%s%%\033[0m' "$color" "$bar" "$color" "$pct_int")
fi

# Rate limit usage with progress bars
make_bar() {
  local pct_val=$1 width=5
  local filled=$(printf '%.0f' "$(echo "$pct_val * $width / 100" | bc -l)")
  local empty=$((width - filled))
  local pct_int=$(printf '%.0f' "$pct_val")
  local color
  if [ "$pct_int" -ge 80 ]; then color="31"
  elif [ "$pct_int" -ge 50 ]; then color="33"
  else color="32"; fi
  local bar=""
  for ((i=0; i<filled; i++)); do bar+="█"; done
  for ((i=0; i<empty; i++)); do bar+="░"; done
  printf '\033[%sm%s\033[0m \033[%sm%s%%\033[0m' "$color" "$bar" "$color" "$pct_int"
}

usage=""
if [ -n "$five_hour" ] || [ -n "$seven_day" ]; then
  usage_parts=""
  [ -n "$five_hour" ] && usage_parts="5h:$(make_bar "$five_hour")"
  [ -n "$seven_day" ] && usage_parts="$usage_parts 7d:$(make_bar "$seven_day")"
  usage=$(printf " %s" "${usage_parts# }")
fi

# Build output with ANSI colors (will be dimmed by Claude Code)
user_host=$(printf '\033[32m %s\033[0m' "$(whoami)")
dir_part=$(printf '\033[34m %s\033[0m' "$short_dir")
git_part=""
[ -n "$git_info" ] && git_part=$(printf '\033[35m %s\033[0m' "$git_info")
sep=$(printf '\033[90m | \033[0m')
model_part=$(printf '\033[36m%s\033[0m' "$model")
ctx_part="$ctx"
usage_part="$usage"

# Collect non-empty sections and join with separator
sections=()
[ -n "$user_host" ] && sections+=("$user_host")
[ -n "$dir_part" ] && sections+=("$dir_part")
[ -n "$git_part" ] && sections+=("$git_part")
[ -n "$model_part" ] && sections+=("$model_part")
[ -n "$ctx_part" ] && sections+=("$ctx_part")
[ -n "$usage_part" ] && sections+=("$usage_part")

result=""
for ((i=0; i<${#sections[@]}; i++)); do
  [ $i -gt 0 ] && result+="$sep"
  result+="${sections[$i]}"
done
printf '%s\n' "$result"
