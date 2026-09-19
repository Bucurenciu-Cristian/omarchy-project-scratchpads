#!/bin/bash

# Behavior tests for the project scratchpad scripts. Runs the real scripts
# against a throwaway $HOME with stubbed hyprctl, menus, notifications and
# terminal, and checks what they dispatch and write.
# Usage: tests/run.sh

set -uo pipefail

ROOT="$(cd -- "$(dirname -- "$0")/.." && pwd)"
BIN="$ROOT/bin"
PASS=0
FAIL=0

setup() {
  T=$(mktemp -d)
  export HOME="$T/home" STUBS="$T/stubs" LOG="$T/log"
  mkdir -p "$HOME/.config/hypr" "$HOME/Work/alpha" "$HOME/Work/beta" "$HOME/Work/New Thing" "$STUBS"
  : >"$LOG"
  : >"$T/answers"
  echo '[]' >"$T/clients.json"
  echo '[{"specialWorkspace":{"name":""}}]' >"$T/monitors.json"

  cat >"$STUBS/hyprctl" <<'EOF'
#!/bin/bash
case "$1" in
  clients) cat "$(dirname "$LOG")/clients.json" ;;
  monitors) cat "$(dirname "$LOG")/monitors.json" ;;
  *) echo "hyprctl $*" >>"$LOG" ;;
esac
EOF
  # Menu stub: pops the next scripted answer and returns it the way
  # omarchy-menu-select does (label, plus "\t<subtext>" when the row has one)
  cat >"$STUBS/menu-select" <<'EOF'
#!/bin/bash
answers="$(dirname "$LOG")/answers"
answer=$(head -1 "$answers"); sed -i 1d "$answers"
echo "menu: $1" >>"$LOG"
shift
[[ $answer == __CANCEL__ || -z $answer ]] && exit 1
for option in "$@"; do
  [[ $option == -- ]] && break
  IFS=$'\t' read -r a b c <<<"$option"
  if [[ $option == *$'\t'* ]]; then label=$b; sub=$c; else label=$a; sub=""; fi
  if [[ $label == "$answer" ]]; then
    [[ -n $sub ]] && printf '%s\t%s\n' "$label" "$sub" || echo "$label"
    exit 0
  fi
done
echo "menu stub: no option '$answer'" >>"$LOG"
exit 1
EOF
  cat >"$STUBS/menu-input" <<'EOF'
#!/bin/bash
answers="$(dirname "$LOG")/answers"
answer=$(head -1 "$answers"); sed -i 1d "$answers"
echo "input: $1" >>"$LOG"
[[ $answer == __CANCEL__ || -z $answer ]] && exit 1
echo "$answer"
EOF
  for cmd in notify-send setsid uwsm-app xdg-terminal-exec herdr omarchy-launch-editor; do
    printf '#!/bin/bash\necho "%s $*" >>"$LOG"\n' "$cmd" >"$STUBS/$cmd"
  done
  # setsid/uwsm-app pass through so the terminal command line is visible
  printf '#!/bin/bash\necho "setsid $*" >>"$LOG"\n' >"$STUBS/setsid"
  chmod +x "$STUBS"/*
  export PATH="$STUBS:$PATH" PROJECTS_MENU_SELECT="$STUBS/menu-select" PROJECTS_MENU_INPUT="$STUBS/menu-input"
}

teardown() { rm -rf "$T"; }

conf() {
  cat >"$HOME/.config/hypr/projects.conf" <<'EOF'
# header comment
alpha|alpha-session|~/Work/alpha|active
beta|beta|~/Work/beta|active
gamma|gamma|~/Work/missing|pending

# [settings]
# daily_switch_budget=2
EOF
}

answers() { printf '%s\n' "$@" >"$T/answers"; }

check() { # description condition...
  local desc="$1"
  shift
  if "$@"; then
    PASS=$((PASS + 1))
  else
    FAIL=$((FAIL + 1))
    echo "FAIL: $desc"
    echo "  log:"; sed 's/^/    /' "$LOG"
  fi
}

logged() { grep -qF -- "$1" "$LOG"; }
current() { [[ $(cat "$HOME/.local/state/hyprland/project-scratchpads/current-project" 2>/dev/null) == "$1" ]]; }
conf_has() { grep -qxF -- "$1" "$HOME/.config/hypr/projects.conf"; }

# --- scratchpad -------------------------------------------------------------
setup
"$BIN/omarchy-project-scratchpad" toggle; rc=$?
check "toggle without config fails" [ $rc -eq 1 ]
check "toggle without config notifies" logged "No project configured"
teardown

setup; conf
"$BIN/omarchy-project-scratchpad" toggle
check "toggle defaults to first project" logged 'hyprctl dispatch hl.dsp.workspace.toggle_special("project:alpha")'
"$BIN/omarchy-project-select" 2
check "select sets current project" current beta
check "select logs a switch" grep -q '|switch|beta|' "$HOME/.local/state/hyprland/project-scratchpads/switch-log"
"$BIN/omarchy-project-scratchpad" send
check "send moves window to current project" logged 'hl.dsp.window.move({ workspace = "special:project:beta", follow = false })'
"$BIN/omarchy-project-scratchpad" send-to 3
check "send-to uses config position" logged 'hl.dsp.window.move({ workspace = "special:project:gamma", follow = false })'
"$BIN/omarchy-project-select" 9; rc=$?
check "select rejects missing position" [ $rc -eq 1 ]
"$BIN/omarchy-project-select" 'x;rm'; rc=$?
check "select rejects non-numeric position" [ $rc -eq 1 ]
check "dir expands ~" [ "$("$BIN/omarchy-project-scratchpad" dir alpha)" == "$HOME/Work/alpha" ]
check "dir falls back to HOME when missing" [ "$("$BIN/omarchy-project-scratchpad" dir gamma)" == "$HOME" ]
check "session field is used" [ "$("$BIN/omarchy-project-scratchpad" session alpha)" == "alpha-session" ]
check "list shows all projects" [ "$("$BIN/omarchy-project-scratchpad" list | tr '\n' ' ')" == "alpha beta gamma " ]
teardown

setup; conf
printf 'bad")name|x|~/Work/alpha|active\n' >>"$HOME/.config/hypr/projects.conf"
check "names Hyprland cannot take are ignored" [ "$("$BIN/omarchy-project-scratchpad" list | tr '\n' ' ')" == "alpha beta gamma " ]
teardown

# --- terminal ---------------------------------------------------------------
setup; conf
"$BIN/omarchy-project-select" 1 >/dev/null
"$BIN/omarchy-project-terminal"
check "terminal opens herdr session in project dir" \
  logged "setsid uwsm-app -- xdg-terminal-exec --dir=$HOME/Work/alpha herdr --session alpha-session"
teardown

# --- status -----------------------------------------------------------------
setup; conf
echo '[{"workspace":{"name":"special:project:alpha"}},{"workspace":{"name":"special:project:alpha"}},{"workspace":{"name":"1"}}]' >"$T/clients.json"
echo '[{"specialWorkspace":{"name":"special:project:alpha"}}]' >"$T/monitors.json"
json=$("$BIN/omarchy-project-status")
check "status is valid JSON" jq -e . <<<"$json" >/dev/null
check "status counts windows" [ "$(jq .windows <<<"$json")" == 2 ]
check "status sees shown scratchpad" [ "$(jq .shown <<<"$json")" == true ]
check "status counts active/total" [ "$(jq -c '[.active,.total,.index]' <<<"$json")" == '[2,3,"1"]' ]
check "status reads budget setting" [ "$(jq .budget <<<"$json")" == 2 ]
teardown

# --- picker -----------------------------------------------------------------
setup; conf
answers beta
"$BIN/omarchy-project-picker"
check "picker switches to a chosen project" current beta
teardown

setup; conf
answers "New project" "Enter a custom path" "~/Work/New Thing" "new-thing"
"$BIN/omarchy-project-picker"
check "new project suggests a clean name" logged "menu: Project name"
check "new project is added" conf_has "new-thing|new-thing|~/Work/New Thing|active"
check "new project lands above settings" [ "$(grep -n 'new-thing' "$HOME/.config/hypr/projects.conf" | cut -d: -f1)" -lt "$(grep -n '# \[settings\]' "$HOME/.config/hypr/projects.conf" | cut -d: -f1)" ]
check "settings block survives" conf_has "# daily_switch_budget=2"
check "new project becomes current" current new-thing
teardown

setup; conf
answers "New project" "No folder yet" "bad name!"
"$BIN/omarchy-project-picker"
check "invalid name is rejected" logged "Invalid name"
check "invalid name is not written" [ "$(grep -c 'bad' "$HOME/.config/hypr/projects.conf")" == 0 ]
answers "New project" "No folder yet" "alpha"
"$BIN/omarchy-project-picker"
check "duplicate name is rejected" logged "already exists"
teardown

setup; conf
answers "Shelve or activate a project" "alpha"
"$BIN/omarchy-project-picker"
check "toggle shelves an active project" conf_has "alpha|alpha-session|~/Work/alpha|pending"
check "comments survive rewrites" conf_has "# header comment"
teardown

setup; conf
answers "Shelved projects…" "gamma" "__CANCEL__"
"$BIN/omarchy-project-picker"
check "unshelve without a reason is cancelled" conf_has "gamma|gamma|~/Work/missing|pending"

"$BIN/omarchy-project-select" 1 >/dev/null; "$BIN/omarchy-project-select" 2 >/dev/null
answers "Shelved projects…" "gamma" "need the fix" "Stay focused"
"$BIN/omarchy-project-picker"
check "budget gate appears once over budget" logged "menu: 2 switches today, over the budget of 2"
check "staying focused keeps it shelved" conf_has "gamma|gamma|~/Work/missing|pending"

answers "Shelved projects…" "gamma" "need the fix" "Switch anyway"
"$BIN/omarchy-project-picker"
check "switching anyway activates the project" conf_has "gamma|gamma|~/Work/missing|active"
check "switching anyway makes it current" current gamma
check "override is logged" grep -q '|budget-override|gamma|' "$HOME/.local/state/hyprland/project-scratchpads/switch-log"
teardown

setup; conf
answers "Delete project" "beta" "Keep beta"
"$BIN/omarchy-project-picker"
check "declining delete keeps the project" conf_has "beta|beta|~/Work/beta|active"
answers "Delete project" "beta" "Delete beta"
"$BIN/omarchy-project-picker"
check "confirming delete removes the project" [ "$(grep -c '^beta|' "$HOME/.config/hypr/projects.conf")" == 0 ]
teardown

setup; conf
"$BIN/omarchy-project-picker" focus-toggle
answers "__CANCEL__"
"$BIN/omarchy-project-picker"
check "focus mode hides shelved entry" bash -c "! grep -q 'Shelved projects' '$LOG'"
check "status reports focus mode" [ "$("$BIN/omarchy-project-status" | jq .focus)" == true ]
teardown

setup; conf
real="$T/real-projects.conf"
mv "$HOME/.config/hypr/projects.conf" "$real"
ln -s "$real" "$HOME/.config/hypr/projects.conf"
answers "Shelve or activate a project" "beta"
"$BIN/omarchy-project-picker"
check "rewrites keep a symlinked config a symlink" [ -L "$HOME/.config/hypr/projects.conf" ]
check "rewrites go through to the real file" grep -qx 'beta|beta|~/Work/beta|pending' "$real"
teardown

echo "passed: $PASS  failed: $FAIL"
(( FAIL == 0 ))
