function nt --description 'Create a timestamped Markdown scratch note'
    if test (count $argv) -gt 0
        and test "$argv[1]" = --list
        if test -d .notes/gml
            tree .notes/gml
        else
            echo 'No notes found in .notes/gml/'
        end
        return
    end

    set -l timestamp (date +%Y-%m-%dT%H-%M-%S)
    set -l note_dir .notes/gml
    set -l filepath

    if test (count $argv) -gt 0
        set -l slug (
            string join '-' $argv |
                string lower |
                string replace -ra '[^a-z0-9-]' ''
        )
        set filepath "$note_dir/$timestamp-$slug.md"
    else
        set filepath "$note_dir/$timestamp.md"
    end

    mkdir -p "$note_dir"

    if git rev-parse --git-dir >/dev/null 2>&1
        set -l exclude (git rev-parse --git-dir)/info/exclude
        mkdir -p (dirname "$exclude")

        if not test -f "$exclude"
            or not grep -qxF '.notes/' "$exclude"
            echo '.notes/' >>"$exclude"
        end
    end

    echo "# $argv" >"$filepath"
    vim "$filepath"
end
