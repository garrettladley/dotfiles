function dd --description 'Show the merge-base diff with delta'
    set -l default_branch (git symbolic-ref --quiet --short refs/remotes/origin/HEAD)
    or begin
        echo "dd: unable to determine origin's default branch; run 'git remote set-head origin --auto'." >&2
        return 1
    end

    git -c core.pager=delta -c delta.syntax-theme=OneHalfDark \
        diff --no-ext-diff (git merge-base $default_branch HEAD) $argv
end
