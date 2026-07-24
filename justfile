set shell := ["bash", "-euo", "pipefail", "-c"]

shell_files := "install.sh tests/install.sh"
fish_files := "fish/config.fish fish/functions/*.fish"

format: (_format "-w" "--write")

format-check: (_format "-d" "--check")

_format shfmt_mode fish_mode:
    shfmt {{shfmt_mode}} -i 2 -ci {{shell_files}}
    fish_indent {{fish_mode}} {{fish_files}}

lint:
    shellcheck {{shell_files}}
    for file in {{fish_files}}; do fish --no-execute "$file"; done

test:
    bash tests/install.sh

ci: format-check lint test
