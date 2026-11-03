function pbwd --description 'Copy the current directory path to the clipboard'
    printf '%s' "$PWD" | pbcopy
end
