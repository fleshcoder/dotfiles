#!/usr/bin/env bash
# Claude Code status line — Kanagawa Dragon palette

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Shorten home directory to ~
short_dir="${cwd/#$HOME/~}"

# Git repo name + branch
git_info=""
if git_out=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null); then
  repo_root=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
  git_info="$(basename "$repo_root")/$git_out"
fi

# === Kanagawa Dragon true-color helpers ===
# Usage: $(tc r g b) → sets foreground to 24-bit color
tc() { printf '\033[38;2;%s;%s;%sm' "$1" "$2" "$3"; }
rst=$'\033[0m'

# Palette
c_springGreen="$(tc 152 187 108)"   # #98BB6C
c_crystalBlue="$(tc 126 156 216)"   # #7E9CD8
c_surimiOrange="$(tc 255 160 102)"  # #FFA066
c_dragonBlue="$(tc 101 133 148)"    # #658594
c_fujiGray="$(tc 114 113 105)"      # #727169
c_waveAqua2="$(tc 122 168 159)"     # #7AA89F
c_springViolet1="$(tc 147 138 169)" # #938AA9
c_sakuraPink="$(tc 210 126 153)"    # #D27E99
c_barOk="$(tc 152 187 108)"         # springGreen
c_barWarn="$(tc 230 195 132)"       # #E6C384 carpYellow
c_barDanger="$(tc 255 93 98)"       # #FF5D62 peachRed
c_barEmpty="$(tc 84 84 109)"        # #54546D sumiInk4

# Severity color for bars: green <50, yellow <80, red >=80
pick_bar_color() {
  local pct=$1
  if [ "$pct" -ge 80 ]; then echo "$c_barDanger"
  elif [ "$pct" -ge 50 ]; then echo "$c_barWarn"
  else echo "$c_barOk"; fi
}

# Build a usage line
# Args: $1=label, $2=percentage, $3=label color
make_usage_line() {
  local label=$1 pct_val=$2 label_color=$3 width=10
  local filled=$(printf '%.0f' "$(echo "$pct_val * $width / 100" | bc -l)")
  [ "$filled" -gt "$width" ] && filled=$width
  local empty=$((width - filled))
  local pct_int=$(printf '%.0f' "$pct_val")
  local bar_color=$(pick_bar_color "$pct_int")
  local bar=""
  for ((i=0; i<filled; i++)); do bar+="▰"; done
  local empty_bar=""
  for ((i=0; i<empty; i++)); do empty_bar+="▱"; done
  # colored label, colored filled bar, dim empty bar, colored pct
  printf '%s%s %s%s%s%s%s %s%3s%%%s' \
    "$label_color" "$label" \
    "$bar_color" "$bar" \
    "$c_barEmpty" "$empty_bar" "$rst" \
    "$bar_color" "$pct_int" "$rst"
}

# === Line 1: identity ===
sep="${c_fujiGray} │ ${rst}"
parts=()
parts+=("$(printf '%s%s  %s%s' "$c_springGreen" $'\xef\x80\x87' "$(whoami)" "$rst")")
parts+=("$(printf '%s%s  %s%s' "$c_crystalBlue" $'\xef\x81\xbc' "$short_dir" "$rst")")
[ -n "$git_info" ] && parts+=("$(printf '%s%s %s%s' "$c_surimiOrange" $'\xee\x9c\xa5' "$git_info" "$rst")")
parts+=("$(printf '%s󰚩 %s%s' "$c_dragonBlue" "$model" "$rst")")

line1=""
for ((i=0; i<${#parts[@]}; i++)); do
  [ $i -gt 0 ] && line1+="$sep"
  line1+="${parts[$i]}"
done

# === Usage lines ===
usage_lines=()
[ -n "$used_pct" ]  && usage_lines+=("$(make_usage_line "$(printf '󰍛') ctx" "$used_pct" "$c_waveAqua2")")
[ -n "$five_hour" ] && usage_lines+=("$(make_usage_line "$(printf '󰔛')  5h" "$five_hour" "$c_springViolet1")")
[ -n "$seven_day" ] && usage_lines+=("$(make_usage_line "$(printf '󰃰')  7d" "$seven_day" "$c_sakuraPink")")

# === Output ===
spacer=" "
printf '%s\n' "$line1"
if [ ${#usage_lines[@]} -gt 0 ]; then
  printf '%s\n' "$spacer"
  for ((i=0; i<${#usage_lines[@]}; i++)); do
    [ $i -gt 0 ] && printf '%s\n' "$spacer"
    printf '%s\n' "${usage_lines[$i]}"
  done
fi
