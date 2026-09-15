import AppKit

// setwallpaper: set the desktop picture on every screen without
// sending AppleEvents (no "wants to control System Events" prompt).
// Usage: setwallpaper <absolute-image-path>

func fail(_ message: String, code: Int32) -> Never {
    fputs("setwallpaper: \(message)\n", stderr)
    exit(code)
}

guard CommandLine.arguments.count == 2 else {
    fail("usage: setwallpaper <image-path>", code: 2)
}

let path = CommandLine.arguments[1]
let url = URL(fileURLWithPath: path)

guard FileManager.default.fileExists(atPath: path) else {
    fail("file not found: \(path)", code: 1)
}

let workspace = NSWorkspace.shared
let screens = NSScreen.screens

guard !screens.isEmpty else {
    fail("no screens found", code: 1)
}

var failed = false
for screen in screens {
    do {
        try workspace.setDesktopImageURL(url, for: screen, options: [:])
    } catch {
        fputs("setwallpaper: failed for a screen: \(error)\n", stderr)
        failed = true
    }
}

exit(failed ? 1 : 0)
