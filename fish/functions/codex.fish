function codex --wraps=codex --description 'Run Codex with the preferred model and reasoning effort'
    set -l model gpt-6-sol
    set -l reasoning_effort high
    set -l NO_COLOR

    command codex --model "$model" \
        --config "model_reasoning_effort=\"$reasoning_effort\"" $argv
end
