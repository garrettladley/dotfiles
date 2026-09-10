fish_add_path "$HOME/bin" "$HOME/.local/bin"

# Make recognized commands, functions, and aliases distinct from plain text.
set -g fish_color_command blue

# Homebrew environment (PATH, MANPATH, INFOPATH)
env SHELL=/opt/homebrew/bin/fish /opt/homebrew/bin/brew shellenv | source

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
