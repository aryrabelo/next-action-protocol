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
