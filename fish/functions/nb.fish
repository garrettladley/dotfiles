function nb --description 'Create a branch with the personal prefix'
    if test (count $argv) -eq 0
        echo 'Usage: nb <branch-name>'
        return 1
    end

    git checkout -b "gml/$argv[1]"
end
