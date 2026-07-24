function am --wraps='git commit -am' --description 'Commit all tracked changes'
    git commit -am $argv
end
