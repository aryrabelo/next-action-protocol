---
name: next-action-protocol
description: Use at the START of any task that will end in a recommendation, a proposed change, a plan, a review, a diagnosis, or a choice the user has to make — anything where the user will have to ask "so what do I do now?". Also use when the user says "next action protocol", asks for unambiguous next steps, complains that answers end vaguely or without a clear recommendation, or wants options laid out to decide between. Once loaded, this protocol applies to EVERY subsequent response in the session, not just the current one.
---

# NEXT ACTION protocol

A response that ends with "let me know how you'd like to proceed" hands the work
back without saying what the work is. This protocol removes that ambiguity: every
recommendation-bearing response ends with exactly one unambiguous action.

## When to Use This Skill

From this point on, for the rest of the session. This is a rule about the shape of
every answer, not a one-off tool. Once it is loaded, apply it to every following
response that carries a recommendation, a proposed change, or a decision — do not
wait to be reminded.

If you want the guarantee rather than the default, paste the always-loaded block
instead: see "Copy and paste this" in the repository README. A skill is selected
on demand by its description, so it may not be loaded on the response where it
matters most.

## The protocol

End every recommendation-bearing response with a `## NEXT ACTION` heading, then a
blank line, then exactly one tag on its own line:

- `[DONE]` — you already executed it. Auto-apply ONLY when all three hold: reversible, scoped to the task, confidence >= 0.8.
- `[DECIDE]` — a choice only the human can make. Lettered options (A/B/C); the recommended one is listed FIRST, as A. Each option states what happened, what the choice does, and what the human must do. If you cannot justify the recommendation in one clause, write `(no recommendation — your call)` on the tag line and give the one-line reason the choice is genuinely human. Options are mutually exclusive, and when "do nothing" is a legitimate path it is a lettered option, never implicit.
- `[HUMAN]` — a step only the human can run; give the exact command or action.
- `[WAIT]` — you are blocked on something external that resolves on its own (background job, CI run, another agent, a timer). Name what you are waiting on, how you will know it finished, and the fallback if it never does. Nothing for the human to do here. A decision is NEVER `[WAIT]` — that is `[DECIDE]`.

Destructive, shared-state, low-confidence, or out-of-scope actions are never `[DONE]`.

Exactly one tag per response. The work is not finished until a response ends in
`[DONE]` — every other tag means the loop is still open.

## Example

```
## NEXT ACTION

[DECIDE] — the production migration is not reversible

The migration passed against staging, but it rewrites `orders.status` in place,
so the production run is not reversible.

A) Ship it behind the dual-write flag first (recommended)
- Recommended because it makes a bad deploy a flag flip instead of a restore.
- Command: ./deploy --flag dual_write_orders
- You deploy; I watch the first batch and report row counts.

B) Run the destructive migration now
- Command: make migrate-prod
- One less release to wait for, but recovery means a point-in-time restore. You
  run it, since it needs the production credential.

C) Do nothing this week
- Nothing to run. I go finish the backfill audit and re-open this decision with
  real numbers.
```

## Referencing a PR or issue

If the work spans more than one repository, never use a bare `#64` — numbers are
per-repository, so a bare one identifies nothing once several repos or checkouts
are in play. Every reference carries `owner/repo`, a full link, and a command with
`--repo owner/repo` spelled out.
