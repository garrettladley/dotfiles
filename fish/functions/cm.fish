function cm --wraps='git commit -m' --description 'Commit with a message'
    git commit -m $argv
end
