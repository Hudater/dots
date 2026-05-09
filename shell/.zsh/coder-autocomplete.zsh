_coder_completions() {
        local -a args completions
        args=("${words[@]:1:$#words}")
        completions=(${(f)"$(COMPLETION_MODE=1 "coder" "${args[@]}")"})
        compadd -a completions
}
compdef _coder_completions coder
