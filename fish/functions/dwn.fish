function dwn --description 'Copy the most recently added download path'
    set -l downloads "$HOME/Downloads"
    if not test -d "$downloads"
        echo "dwn: downloads folder not found: $downloads" >&2
        return 1
    end

    if not command ls -A "$downloads" >/dev/null 2>&1
        echo "dwn: macOS denied access to $downloads; check your terminal app's permissions under System Settings > Privacy & Security > Files & Folders or Full Disk Access" >&2
        return 1
    end

    set -l latest_path
    set -l latest_time

    for path in (find "$downloads" -type f -print0 | string split0)
        set -l added_at (stat -f '%B' "$path" 2>/dev/null)
        if test -z "$added_at"
            continue
        end

        if test "$added_at" -lt 0
            set added_at (stat -f '%m' "$path" 2>/dev/null)
        end
        if test -z "$added_at"
            continue
        end

        if test -z "$latest_path"
            set latest_path "$path"
            set latest_time "$added_at"
        else if test "$added_at" -gt "$latest_time"
            set latest_path "$path"
            set latest_time "$added_at"
        end
    end

    if test -z "$latest_path"
        echo "dwn: no files found in $downloads" >&2
        return 1
    end

    printf '%s' "$latest_path" | pbcopy
    or return $status

    printf '%s\n' "$latest_path"
end
