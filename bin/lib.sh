# Shared helpers for the project scratchpad scripts. Source, don't execute.
# Config format: name|session|dir[,dir...]|status (status defaults to "active")

CONFIG_FILE="${PROJECTS_CONFIG:-$HOME/.config/hypr/projects.conf}"
STATE_DIR="${PROJECTS_STATE_DIR:-$HOME/.local/state/hyprland/project-scratchpads}"
CURRENT_FILE="$STATE_DIR/current-project"
SWITCH_LOG="$STATE_DIR/switch-log"
FOCUS_FILE="$STATE_DIR/focus-mode"
# shellcheck disable=SC2034 # used by the scripts that source this file
BIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$STATE_DIR"

# Project lines in config order; comments, blank lines and lines whose name is
# not letters, numbers, - and _ are skipped (names end up in Hyprland Lua strings)
project_lines() {
  [[ -f $CONFIG_FILE ]] || return 0
  grep -E '^[A-Za-z0-9_-]+\|' "$CONFIG_FILE" || true
}

project_line_by_index() { [[ $1 =~ ^[1-9][0-9]*$ ]] && project_lines | sed -n "${1}p"; }
project_line_by_name() { project_lines | grep -- "^${1}|" | head -1; }
project_index() { project_lines | cut -d'|' -f1 | grep -nx -- "$1" | cut -d: -f1; }
field() { cut -d'|' -f"$2" <<<"$1"; }

project_status() {
  local status
  status=$(field "$1" 4)
  echo "${status:-active}"
}

# Read "# key=value" from the "# [settings]" block
setting() {
  local value=""
  [[ -f $CONFIG_FILE ]] && value=$(sed -n '/^# \[settings\]/,/^$/{ s/^# '"$1"'=//p }' "$CONFIG_FILE" | head -1)
  echo "${value:-$2}"
}

switch_budget() {
  local budget
  budget=$(setting daily_switch_budget 3)
  [[ $budget =~ ^[0-9]+$ ]] && echo "$budget" || echo 3
}

# Replace a project's line in the config (an empty replacement deletes it).
# Writes through a symlinked config and leaves comments and settings alone.
replace_project_line() { # name [new-line]
  local target tmp
  target=$(readlink -f -- "$CONFIG_FILE")
  tmp=$(mktemp "$STATE_DIR/conf.XXXXXX")
  awk -v name="$1" -v repl="${2:-}" '
    !/^[[:space:]]*#/ && index($0, name "|") == 1 { if (repl != "") print repl; next }
    { print }
  ' "$target" >"$tmp" && cat "$tmp" >"$target"
  rm -f "$tmp"
}

# Add a project line, above the settings block when there is one
append_project_line() {
  local target tmp
  target=$(readlink -f -- "$CONFIG_FILE")
  if grep -q '^# \[settings\]' "$target" 2>/dev/null; then
    tmp=$(mktemp "$STATE_DIR/conf.XXXXXX")
    awk -v line="$1" '/^# \[settings\]/ && !done { print line; print ""; done = 1 } { print }' "$target" >"$tmp" &&
      cat "$tmp" >"$target"
    rm -f "$tmp"
  else
    [[ -s $target && -n $(tail -c1 "$target") ]] && echo >>"$target"
    printf '%s\n' "$1" >>"$target"
  fi
}

current_project() {
  local project=""
  [[ -f $CURRENT_FILE ]] && project=$(<"$CURRENT_FILE")
  if [[ -n $project && -n $(project_line_by_name "$project") ]]; then
    echo "$project"
  else
    project_lines | head -1 | cut -d'|' -f1
  fi
}

# First directory of a project, with ~ expanded; $HOME when it does not exist
project_dir() {
  local line dir
  line=$(project_line_by_name "$1")
  dir=$(field "$line" 3 | cut -d',' -f1)
  dir="${dir/#\~/$HOME}"
  [[ -n $dir && -d $dir ]] && echo "$dir" || echo "$HOME"
}

project_session() {
  local session
  session=$(field "$(project_line_by_name "$1")" 2)
  echo "${session:-$1}"
}

set_current_project() { echo "$1" >"$CURRENT_FILE"; }

log_action() {
  printf '%s|%s|%s|%s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" "${2:-}" "${3:-}" >>"$SWITCH_LOG"
}

today_switch_count() {
  local count
  count=$(grep -c "^$(date '+%Y-%m-%d').*|switch|" "$SWITCH_LOG" 2>/dev/null) || true
  echo "${count:-0}"
}

focus_mode() {
  if [[ ! -f $FOCUS_FILE ]]; then
    [[ $(setting focus_mode false) == true ]] && echo 1 >"$FOCUS_FILE" || echo 0 >"$FOCUS_FILE"
  fi
  [[ $(<"$FOCUS_FILE") == 1 ]]
}

clients_json() { hyprctl clients -j 2>/dev/null || echo '[]'; }

window_count() { # name [clients-json]
  local json="${2:-$(clients_json)}"
  jq --arg ws "special:project:$1" '[.[] | select(.workspace.name == $ws)] | length' <<<"$json" 2>/dev/null || echo 0
}

# Newline-separated project names that have a dev server running inside their directory
projects_with_servers() {
  local pid cwd line name dir
  local -a cwds=()
  for pid in $(pgrep -x 'bun|node|pnpm|python|python3|uv|deno' 2>/dev/null); do
    cwd=$(readlink "/proc/$pid/cwd" 2>/dev/null) && cwds+=("$cwd")
  done
  (( ${#cwds[@]} )) || return 0
  while IFS= read -r line; do
    name=$(field "$line" 1)
    dir=$(project_dir "$name")
    [[ $dir == "$HOME" ]] && continue
    for cwd in "${cwds[@]}"; do
      if [[ $cwd == "$dir" || $cwd == "$dir"/* ]]; then echo "$name"; break; fi
    done
  done < <(project_lines)
}

notify() { notify-send -a "Projects" "$1" "${2:-}" 2>/dev/null || true; }
