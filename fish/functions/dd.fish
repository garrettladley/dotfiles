function dd --description 'Show the merge-base diff with delta'
    git -c core.pager=delta -c delta.syntax-theme=OneHalfDark \
        diff --no-ext-diff (git merge-base origin/main HEAD) $argv
end
