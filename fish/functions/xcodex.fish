function xcodex --wraps=codex --description 'Run Codex without project docs or skill instructions'
    codex \
        --config project_doc_max_bytes=0 \
        --config skills.include_instructions=false \
        $argv
end
