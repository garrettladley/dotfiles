function xluna --wraps=codex --description 'Run Codex with Luna and xhigh reasoning effort'
    set -l model gpt-6-luna
    set -l reasoning_effort xhigh
    set -l NO_COLOR

    command codex --model "$model" \
        --config "model_reasoning_effort=\"$reasoning_effort\"" $argv
end
