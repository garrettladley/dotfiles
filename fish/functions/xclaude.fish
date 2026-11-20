function xclaude --wraps=claude --description 'Run Claude Code without CLAUDE.md files or project settings, keeping user skills invocable'
    CLAUDE_CODE_DISABLE_CLAUDE_MDS=1 command claude --setting-sources user $argv
end
