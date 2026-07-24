function prl --description 'Print the current pull request URL'
    gh pr view --json url --jq .url $argv
end
