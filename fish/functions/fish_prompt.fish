function fish_prompt
    set -l cwd_abbr (string replace -r "^$HOME/[Dd]esktop/code/" "" "$PWD")
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
