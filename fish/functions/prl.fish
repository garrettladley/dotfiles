function prl --description 'Print the current pull request URL'
    set -lx GH_NO_UPDATE_NOTIFIER 1
    gh pr view --json url --jq .url $argv 2>| command cat >&2
    return $pipestatus[1]
end
