---
name: gml-ascii-diagrams
description: Call-graph-style text diagrams for pull requests and agent sessions. Use when visualizing execution paths, nested structures, branching behavior, filtering, or test cases.
---

Text diagram standards for pull requests and agent sessions.

## Diagrams

Use a fenced `text` block with a single rooted tree:

```text
get_capabilities(filter_enabled=true)
└── filter_toolset(toolset)
    ├── enabled child
    │   └── result: keep
    └── disabled child
        └── result: prune
```

- start with the entrypoint, subject, or scenario
- use `├──`, `└──`, and `│` to express hierarchy
- use code identifiers directly without Markdown backticks
- include arguments only when they explain a branch
- describe observable outcomes with `result:` leaves
- omit incidental calls and repeated paths
- prefer one complete tree over multiple fragments
- do not use Mermaid, decorative boxes, arrows, or emoji

## Pull Requests

Place the diagram before the bullet list when it summarizes the whole change.
Nest it beneath a bullet when it supports only that item.

Follow `gml-git-etiquette` for the surrounding description. Use the prose to
explain implications and verification instead of restating the tree.

## Agent Sessions

Use a diagram when hierarchy or branching is easier to understand visually.
Introduce it with at most one sentence, then explain only details that are not
visible in the tree.
