#!/bin/bash
# Jump to the last-used workspace of an env, defaulting to home base.
# Usage: goto-env.sh work|personal
# Called from the alt-w / alt-e bindings AFTER the mode flip (bindings are the
# only thing that can switch modes; this script only moves workspaces).
ENV="$1"
STATE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/aerospace/env"

get() { grep -E "^$1=" "$STATE_FILE" 2>/dev/null | cut -d= -f2-; }
WORK="$(get WORK)";         [[ "$WORK" == W* ]]     || WORK=W1
PERSONAL="$(get PERSONAL)"; [[ "$PERSONAL" == P* ]] || PERSONAL=P1

case "$ENV" in
    work)     TARGET="$WORK" ;;
    personal) TARGET="$PERSONAL" ;;
    *) echo "goto-env.sh: usage: goto-env.sh work|personal" >&2; exit 1 ;;
esac

exec /opt/homebrew/bin/aerospace workspace "$TARGET"
