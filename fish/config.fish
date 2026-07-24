fish_add_path "$HOME/bin" "$HOME/.local/bin"

if test -f "$HOME/.config/fish/secrets.fish"
    source "$HOME/.config/fish/secrets.fish"
end

if status is-interactive
    set -g fish_greeting

    if type -q zoxide
        zoxide init fish | source
    end

    if type -q fzf
        fzf --fish | source
    end
end
