function ga --wraps='git add -p' --description 'Interactively stage changes'
    git add -p $argv
end
