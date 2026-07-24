function gd --description 'Show the merge-base diff with difftastic'
    env GIT_EXTERNAL_DIFF=difft git diff \
        (git merge-base origin/main HEAD) $argv
end
