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

Optional. Skip this section if you only ever work in one repository.

NEVER a bare `#64`. Numbers are per-repository, so once you work across several
repos — or several checkouts of the same repo — a bare number identifies nothing
and costs a round trip to resolve.

Every reference to a pull request or issue is qualified by `owner/repo`. Any option
pointing at one carries at least these lines:

```
A) <what the choice does> (recommended)
- Link: https://github.com/<owner>/<repo>/pull/<N>
- Command: <the exact command, with --repo <owner>/<repo> spelled out>
```

The link is the unambiguous identity; the command names the repo explicitly so that
pasting it from any working directory targets the right one, instead of resolving
against whatever happens to be checked out.

If your harness has its own URI scheme for pulls and issues, add that line too, in
the fully qualified `owner/repo/<N>` form.

Same rule for anything already closed that you mention for reference: link it.
