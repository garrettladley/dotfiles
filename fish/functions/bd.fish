function bd --description 'Show the merge-base diff with bat'
    env -u GIT_EXTERNAL_DIFF git diff (git merge-base origin/main HEAD) $argv |
        bat --language=diff --paging=never
end
