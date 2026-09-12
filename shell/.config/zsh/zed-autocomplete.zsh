#compdef zed

autoload -U is-at-least

_zed() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line
    _arguments "${_arguments_options[@]}" : \
'--user-data-dir=[Sets a custom directory for all user data (e.g., database, extensions, logs). This overrides the default platform-specific data directory location\: \`~/Library/Application Support/Zed\`]:DIR:_files -/' \
'--zed=[Custom path to Zed.app or the zed binary]:ZED:_files' \
'--dev-server-token=[Run zed in dev-server mode]:DEV_SERVER_TOKEN:_default' \
'*--diff=[Pairs of file paths to diff. Can be specified multiple times. When directories are provided, recurses into them and shows all changed files in a single multi-diff view]:OLD_PATH:_files:OLD_PATH:_files' \
'--completions=[Generate shell completions for Zed]:SHELL:(bash elvish fish nushell powershell zsh)' \
'--askpass=[Used for SSH/Git password authentication, to remove the need for netcat as a dependency, by having Zed act like netcat communicating over a Unix socket]:ASKPASS:_default' \
'-w[Wait for all of the given paths to be opened/closed before exiting]' \
'--wait[Wait for all of the given paths to be opened/closed before exiting]' \
'-a[Add files to the currently open workspace]' \
'--add[Add files to the currently open workspace]' \
'-n[Create a new workspace]' \
'--new[Create a new workspace]' \
'-r[Reuse an existing window, replacing its workspace]' \
'--reuse[Reuse an existing window, replacing its workspace]' \
'-e[Open in existing Zed window]' \
'--existing[Open in existing Zed window]' \
'--classic[Use the classic open behavior\: new window for directories, reuse for files]' \
'-v[Print Zed'\''s version and the app path]' \
'--version[Print Zed'\''s version and the app path]' \
'--foreground[Run zed in the foreground (useful for debugging)]' \
'--system-specs[Not supported in Zed CLI, only supported on Zed binary Will attempt to give the correct command to run]' \
'--dev-container[Open the project in a dev container]' \
'--uninstall[Uninstall Zed from user system]' \
'-h[Print help (see more with '\''--help'\'')]' \
'--help[Print help (see more with '\''--help'\'')]' \
'*::paths_with_position -- The paths to open in Zed (space-separated):_files' \
&& ret=0
}

(( $+functions[_zed_commands] )) ||
_zed_commands() {
    local commands; commands=()
    _describe -t commands 'zed commands' commands "$@"
}

if [ "$funcstack[1]" = "_zed" ]; then
    _zed "$@"
else
    compdef _zed zed
fi
