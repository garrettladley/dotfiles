function pus --wraps='git push' --description 'Push Git changes'
    git push $argv
end
