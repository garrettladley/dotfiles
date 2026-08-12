function m --description 'Check out the remote default branch'
    set -l default_branch (git symbolic-ref --quiet --short refs/remotes/origin/HEAD)
    or begin
        echo "m: unable to determine origin's default branch; run 'git remote set-head origin --auto'." >&2
        return 1
    end

    git checkout (string replace 'origin/' '' -- $default_branch) $argv
end
