function pp --description 'Prune local branches whose upstream is gone'
    set -l dry_run 0

    for arg in $argv
        switch $arg
            case -n --dry-run
                set dry_run 1
            case -h --help
                echo 'Usage: pp [--dry-run]'
                echo
                echo 'Fetch with --prune, then delete local branches whose upstream is gone.'
                return 0
            case '*'
                echo "pp: unsupported argument '$arg'" >&2
                return 1
        end
    end

    if not git rev-parse --git-dir >/dev/null 2>&1
        echo 'pp: not in a Git repository' >&2
        return 1
    end

    git fetch --prune
    or return $status

    set -l gone_branches

    for line in (git for-each-ref \
            --format='%(HEAD)|%(refname:short)|%(upstream:track)' refs/heads)
        set -l parts (string split '|' -- "$line")
        set -l head_marker "$parts[1]"
        set -l branch_name "$parts[2]"
        set -l upstream_track "$parts[3]"

        if test "$upstream_track" = '[gone]'
            if test "$head_marker" = '*'
                echo "pp: skipping current branch '$branch_name'" >&2
                continue
            end

            set -a gone_branches "$branch_name"
        end
    end

    if test (count $gone_branches) -eq 0
        echo 'No local branches with gone upstreams.'
        return 0
    end

    if test "$dry_run" -eq 1
        printf '%s\n' $gone_branches
        return 0
    end

    for branch_name in $gone_branches
        git branch -D -- "$branch_name"
    end
end
