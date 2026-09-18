---
name: gml-ascii-diagrams
description: Text diagrams for architecture, data flow, lifecycles, execution paths, hierarchies, branching behavior, filtering, or test cases.
---

Text diagram standards.

## Diagrams

Use a fenced `text` block. Choose the form that makes the important relationship
easiest to understand; a diagram does not need to be a tree or have a single
root.

Useful forms include, but are not limited to:

- rooted trees for call graphs, nested structures, and branching behavior
- boxes and labeled arrows for architecture, ownership, and data flow
- timelines or sequences for interactions that unfold over time
- state-transition diagrams for lifecycle behavior
- multiple small, labeled views when distinct concerns would be crowded into one
  diagram
- hybrids of these forms when the subject crosses boundaries

A compact tree remains a good option when the subject is actually hierarchical:

```text
get_capabilities(filter_enabled=true)
└── filter_toolset(toolset)
    ├── enabled child
    │   └── result: keep
    └── disabled child
        └── result: prune
```

- make the main subject, entrypoint, or direction of flow apparent
- use line-drawing characters, arrows, boxes, spacing, and labels wherever they
  carry meaning
- use code identifiers directly without Markdown backticks
- include arguments, payloads, transitions, and outcomes only when they clarify
  the behavior being explained
- omit incidental detail and repeated paths
- prefer a readable overview over rigid adherence to one visual grammar
- do not use Mermaid or decorative elements that do not communicate structure

## Usage

Use a diagram when relationships or behavior are easier to understand visually.
Briefly introduce it when the context is not already clear, then explain only
details that are not visible in the diagram.
