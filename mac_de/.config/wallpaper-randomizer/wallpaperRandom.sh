#!/usr/bin/env bash

# Mac-only random wallpaper selector.
# Uses the local `setwallpaper` helper (NSWorkspace API) so macOS never
# prompts for permission. Falls back to osascript only if the helper
# is unavailable (that fallback triggers a System Events prompt).

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HELPER="${SCRIPT_DIR}/setwallpaper"

# Wallpapers Path (must be set in env)
wallpaperDir="$WALL_DIR"

if [[ -z "${wallpaperDir}" ]]; then
    echo "WALL_DIR is not set."
    exit 1
fi

if [[ ! -d "${wallpaperDir}" ]]; then
    echo "Wallpaper directory not found: ${wallpaperDir}"
    exit 1
fi

# Retrieve image files as a list (newline-safe loop handles spaces)
PICS=()
while IFS= read -r pic; do
    [[ -n "${pic}" ]] && PICS+=("${pic}")
done < <(find "${wallpaperDir}" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \) | sort)

if [[ ${#PICS[@]} -eq 0 ]]; then
    echo "No wallpapers found in: ${wallpaperDir}"
    exit 1
fi

# Use date variable to increase randomness
randomNumber=$(( ($(date +%s) + RANDOM) + $$ ))
randomPicture="${PICS[$(( randomNumber % ${#PICS[@]} ))]}"

# Ask once to build the helper if it is missing. Returns 0 when the
# helper is usable afterwards, 1 when the caller should fall back to
# osascript (which prompts for System Events access on every wake).
ensureHelper() {
    if [[ -x "${HELPER}" ]]; then
        return 0
    fi

    local prompt="The wallpaper helper (setwallpaper) is not built. Without it, macOS will ask you to allow control of System Events on EVERY screen wake. Compile it now?"
    local answer=""

    if [[ -t 0 ]]; then
        read -r -p "${prompt} [Y/n] " answer
        case "${answer}" in
            [nN]*) return 1 ;;
        esac
    else
        answer="$(osascript -e "display dialog \"${prompt}\" buttons {\"Skip\", \"Compile\"} default button \"Compile\" with title \"Wallpaper setup\"" 2>/dev/null)" || return 1
        [[ "${answer}" == *"Compile"* ]] || return 1
    fi

    if ! command -v swiftc &>/dev/null; then
        echo "swiftc not found (install Xcode Command Line Tools). Falling back to osascript; expect a System Events prompt." >&2
        return 1
    fi

    if swiftc -O -o "${HELPER}" "${SCRIPT_DIR}/setwallpaper.swift" -framework AppKit >&2; then
        chmod +x "${HELPER}"
        return 0
    fi

    echo "Failed to compile setwallpaper. Falling back to osascript; expect a System Events prompt." >&2
    return 1
}

# Set wallpaper on all monitors to the same image
executeCommand() {
    if ensureHelper; then
        "${HELPER}" "$1"
    else
        osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$1\""
    fi

    ln -sf "$1" "$HOME/.current_wallpaper"
}

executeCommand "${randomPicture}"
