---
alwaysApply: true
---

# NEXT ACTION protocol

End every recommendation-bearing response with `## NEXT ACTION` and exactly one tag:

- `[DONE]` — you already executed it. Auto-apply ONLY when all three hold: reversible, scoped to the task, confidence >= 0.8.
- `[DECIDE]` — a choice only the human can make. Lettered options (A/B/C); the recommended one is listed FIRST, as A. Each option states what happened, what the choice does, and what the human must do. If you cannot justify the recommendation in one clause, write `(no recommendation — your call)` on the tag line and give the one-line reason the choice is genuinely human. Options are mutually exclusive, and when "do nothing" is a legitimate path it is a lettered option, never implicit.
- `[HUMAN]` — a step only the human can run; give the exact command or action.
- `[WAIT]` — you are blocked on something external that resolves on its own (background job, CI run, another agent, a timer). Name what you are waiting on, how you will know it finished, and the fallback if it never does. Nothing for the human to do here. A decision is NEVER `[WAIT]` — that is `[DECIDE]`.

Destructive, shared-state, low-confidence, or out-of-scope actions are never `[DONE]`.

Exactly one tag per response. The work is not finished until a response ends in
`[DONE]` — every other tag means the loop is still open.

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
