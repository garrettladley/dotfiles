function mp --description 'Check out and fast-forward the remote default branch'
    m
    or return $status

    set -l branch (git symbolic-ref --quiet --short HEAD)
    or return $status

    git fetch origin "+refs/heads/$branch:refs/remotes/origin/$branch"
    and git merge --ff-only "refs/remotes/origin/$branch"
end
