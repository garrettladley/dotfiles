function fish_prompt
    set -l cwd_abbr "$PWD"
    set -l project_roots "$HOME/Desktop/code" "$HOME/desktop/code" "$HOME/dev"

    if set -q FISH_PROMPT_PROJECT_ROOTS
        set -a project_roots $FISH_PROMPT_PROJECT_ROOTS
    end

    for root in $project_roots
        set -l root_regex (string escape --style=regex -- (string trim --right --chars=/ "$root"))
        set -l collapsed (string replace --regex "^$root_regex/" "" -- "$PWD")

        if test "$collapsed" != "$PWD"
            set cwd_abbr "$collapsed"
            break
        end
    end

    echo -n (set_color blue)"$cwd_abbr "(set_color normal)

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set -l git_branch (
            git symbolic-ref --short HEAD 2>/dev/null
            or git rev-parse --short HEAD 2>/dev/null
        )
        set -l git_status (git status --porcelain -uno 2>/dev/null)

        if test -n "$git_status"
            echo -n (set_color yellow)"($git_branch) "(set_color normal)
        else
            echo -n (set_color green)"($git_branch) "(set_color normal)
        end
    end
end
