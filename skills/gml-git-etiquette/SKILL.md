---
name: gml-git-etiquette
description: Git etiquette for commits and pull requests. Conventional Commits format, lowercase PR descriptions with backtick-wrapped code nouns, plain bullet-point bodies. Use when committing, making a PR, or shipping changes.
---

Git etiquette standards for commits and pull requests.

## Commit Messages

Commit messages must follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) format:

```text
<type>(<optional scope>): <description>
```

Use `feat`, `fix`, `perf`, `revert`, `docs`, `chore`, `ci`, `refactor`,
`test`, `build`, or `style` as the type. The optional scope describes the
affected area.

## Pull Requests

PR titles follow the same Conventional Commits format as commit messages.
Choose the type based on the overall intent of every commit on the branch.

The body is a holistic three-to-five-item bullet list:

- use no section headers, test-plan sections, checkboxes, or generated footers
- use lowercase prose
- wrap code nouns, file paths, functions, variables, and types in backticks
- rewrite the complete description when the branch changes instead of appending
  individual commit summaries

## Branches

Prefix branch names with `gml/` and use kebab-case:

```text
gml/<short-descriptive-name>
```

Before creating a PR, inspect the full branch status, diff, and commit history.
