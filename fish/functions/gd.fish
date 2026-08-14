function gd --description 'Show the merge-base diff with difftastic'
    set -l default_branch (git symbolic-ref --quiet --short refs/remotes/origin/HEAD)
    or begin
        echo "gd: unable to determine origin's default branch; run 'git remote set-head origin --auto'." >&2
        return 1
    end

    env GIT_EXTERNAL_DIFF=difft git diff \
        (git merge-base $default_branch HEAD) $argv
end
