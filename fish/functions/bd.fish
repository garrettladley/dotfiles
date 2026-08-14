function bd --description 'Show the merge-base diff with bat'
    set -l default_branch (git symbolic-ref --quiet --short refs/remotes/origin/HEAD)
    or begin
        echo "bd: unable to determine origin's default branch; run 'git remote set-head origin --auto'." >&2
        return 1
    end

    env -u GIT_EXTERNAL_DIFF git diff (git merge-base $default_branch HEAD) $argv |
        bat --language=diff --paging=never
end
