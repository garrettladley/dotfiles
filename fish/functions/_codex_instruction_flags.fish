function _codex_instruction_flags --description 'Print the Codex flags that disable project docs and skill instructions'
    printf '%s\n' --config project_doc_max_bytes=0 --config skills.include_instructions=false
end
