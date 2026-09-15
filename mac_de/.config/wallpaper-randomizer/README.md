# wallpaper-randomizer (macOS)

Picks a random wallpaper from `$WALL_DIR` and sets it on every monitor.
Stowed to `~/.config/wallpaper-randomizer/`.

## Files

| File | Tracked? | Purpose |
|---|---|---|
| `wallpaperRandom.sh` | yes | Picks a random image, sets it, updates `~/.current_wallpaper` |
| `setwallpaper.swift` | yes | Helper source: sets wallpaper via `NSWorkspace` (no permission prompt) |
| `setwallpaper` | **no** (gitignored) | Compiled helper binary |
| `on-wakeup.sh` | yes | sleepwatcher hook: system wake |
| `on-displaywakeup.sh` | yes | sleepwatcher hook: screen off/on |
| `com.username.sleepwatcher.plist` | yes | LaunchAgent template (`userName` is a placeholder, see below) |

## Build the helper

The script auto-builds it on first run **after asking you**.
To build manually:

```sh
cd ~/.config/wallpaper-randomizer
swiftc -O -o setwallpaper setwallpaper.swift -framework AppKit
```

Requires Xcode Command Line Tools (`swiftc`).

> If you skip compiling, the script falls back to `osascript` + System Events,
> and macOS will pop up **"wants to control System Events" on every screen
> wake**. Building the helper avoids that prompt permanently.

## sleepwatcher plist setup

`brew install sleepwatcher` only watches system sleep/wake. For screen
off/on you need the `-W` (display wakeup) flag, which this custom
LaunchAgent adds. `~` does **not** expand in plist files, so use real paths:

```sh
# 1. Install the template (replace userName with your login name)
cp ~/.config/wallpaper-randomizer/com.username.sleepwatcher.plist \
   ~/Library/LaunchAgents/com.$USER.sleepwatcher.plist
sed -i '' "s/userName/$USER/g" ~/Library/LaunchAgents/com.$USER.sleepwatcher.plist

# 2. Hand over from brew's service (it lacks -W and would double-fire)
brew services stop sleepwatcher

# 3. Load and verify
launchctl load -w ~/Library/LaunchAgents/com.$USER.sleepwatcher.plist
ps aux | grep '[s]leepwatcher'   # expect -w ...on-wakeup.sh -W ...on-displaywakeup.sh
```

Logs go to `/tmp/wallpaper-unlock.log`.

## Aerospace shortcut

In `aerospace.toml` (`[mode.main.binding]`):

```toml
alt-shift-n = 'exec-and-forget WALL_DIR=~/syncthing/PC-Walls ~/.config/wallpaper-randomizer/wallpaperRandom.sh'
```

`~` works here because `exec-and-forget` runs via `/bin/bash -c`.
(`WALL_DIR` must be passed explicitly — Aerospace doesn't inherit your shell env.)
Then `aerospace reload-config`.
