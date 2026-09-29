function _codex_no_instructions --description 'Run Codex without project docs or skill instructions'
    command codex \
        --config project_doc_max_bytes=0 \
        --config skills.include_instructions=false \
        $argv
end
