#!/bin/bash
# Runs on every focused-workspace change (see exec-on-workspace-change in
# aerospace.toml). Remembers the last W* workspace as WORK and the last P*
# workspace as PERSONAL. Commons (A/S/D/F) and legacy names are ignored.
#
# State lives in ~/.cache on purpose: it rewrites on every workspace switch
# (~10 bytes a write, invisible to SSD wear), must never sync over Syncthing,
# and every failure mode degrades to W1/P1 defaults. Deleting the file is safe.

STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/aerospace"
STATE_FILE="$STATE_DIR/env"
FOCUSED="${AEROSPACE_FOCUSED_WORKSPACE:-}"

case "$FOCUSED" in
    W*) KEY=WORK ;;
    P*) KEY=PERSONAL ;;
    *) exit 0 ;;
esac

# This Aerospace beta sometimes delivers workspace events late or duplicated
# (one switch can fire several callbacks). Trust only events that match the
# actually-focused workspace right now; drop stale phantoms. A dropped genuine
# event is harmless: the next switch re-records, and fast alt-1..alt-9 runs
# still end on the correct final workspace.
ACTUAL="$(/opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null)"
[[ "$ACTUAL" == "$FOCUSED" ]] || exit 0

mkdir -p "$STATE_DIR" || exit 0

get() { grep -E "^$1=" "$STATE_FILE" 2>/dev/null | cut -d= -f2-; }

# Already recorded (covers duplicate callback fires): don't touch the disk.
[[ "$(get "$KEY")" == "$FOCUSED" ]] && exit 0

WORK="$(get WORK)";         [[ "$WORK" == W* ]]     || WORK=W1
PERSONAL="$(get PERSONAL)"; [[ "$PERSONAL" == P* ]] || PERSONAL=P1
if [[ "$KEY" == WORK ]]; then WORK="$FOCUSED"; else PERSONAL="$FOCUSED"; fi

TMP="$STATE_FILE.tmp.$$"
printf 'WORK=%s\nPERSONAL=%s\n' "$WORK" "$PERSONAL" > "$TMP" && mv "$TMP" "$STATE_FILE"
