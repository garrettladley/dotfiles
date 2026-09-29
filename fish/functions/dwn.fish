function dwn --description 'Copy the most recently added download path'
    set -l downloads "$HOME/Downloads"
    if not test -d "$downloads"
        echo "dwn: downloads folder not found: $downloads" >&2
        return 1
    end

    set -l latest_record (
        find "$downloads" -type f -exec stat -f '%B %N' {} + |
            sort -nr |
            head -n 1
    )

    if test -z "$latest_record"
        echo "dwn: no files found in $downloads" >&2
        return 1
    end

    set -l latest_path (string replace --regex '^-?[0-9]+ ' '' -- "$latest_record")
    printf '%s' "$latest_path" | pbcopy
    or return $status

    printf '%s\n' "$latest_path"
end
