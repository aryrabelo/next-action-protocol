---
alwaysApply: true
---

# NEXT ACTION protocol

End every recommendation-bearing response with `## NEXT ACTION` and exactly one tag:

- `[DONE]` — you already executed it. Auto-apply ONLY when all three hold: reversible, scoped to the task, confidence >= 0.8.
- `[WAIT]` — decision needed: lettered options (A/B/C), one marked `(recommended)`. Each option states what happened, what the choice does, and what the human must do.
  - The recommended option is listed FIRST, as A — the reader meets the default before the alternatives.
  - Can't justify it in one clause ("recommended because <reason>")? Then there is no recommendation: write `(no recommendation — your call)` on the block header line and say in one line why the choice is genuinely human (conflicting values, information only the human has, irreversible cost either way). Marking A by reflex defeats the point of `[WAIT]`.
  - Options are mutually exclusive, and when doing nothing is a legitimate path it is one of the lettered options, never implicit.
- `[HUMAN]` — a step only the human can run; give the exact command or action.

Destructive, shared-state, low-confidence, or out-of-scope actions are never `[DONE]`.

## Referencing a PR or issue

NEVER a bare `#64`. Dozens of worktrees across dozens of repos share numbers, so a
bare number names nothing and costs a round trip to resolve. This holds in every
repo, including the ones served by the orchestrator.

Any option pointing at a PR or issue carries three lines:

```
A) <what the choice does> (recommended)
- Link: https://github.com/<owner>/<repo>/pull/<N>
- OMP: pr://<owner>/<repo>/<N>
- Comando: <the exact command, with --repo <owner>/<repo> spelled out>
```

`issue://<owner>/<repo>/<N>` for issues. Always the three-segment form, never the
bare `pr://<N>` — that resolves against the current checkout, which is the wrong
repo whenever the answer spans repos.

Same rule for anything already closed that you mention for reference: link it.
