function mp --description 'Check out the remote default branch and pull'
    set -l default_branch (git symbolic-ref --quiet --short refs/remotes/origin/HEAD)
    or begin
        echo "mp: unable to determine origin's default branch; run 'git remote set-head origin --auto'." >&2
        return 1
    end

    git checkout (string replace 'origin/' '' -- $default_branch)
    and pul $argv
end
