function fuck --description 'Undo the latest commit while preserving its changes'
    git reset --soft HEAD~1 $argv
end
