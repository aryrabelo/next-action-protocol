# NEXT ACTION protocol

A coding agent that ends with "let me know how you'd like to proceed" has handed
the work back without saying what the work is. This protocol fixes that: every
recommendation-bearing response ends with exactly one unambiguous action, and when
the decision belongs to the human, the options are spelled out instead of implied.

Three tags, one per response:

| Tag | Meaning | Requirement |
| --- | --- | --- |
| `[DONE]` | The agent already executed it. | Auto-apply only when all three hold: reversible, scoped to the task, confidence >= 0.8. |
| `[WAIT]` | A decision is needed. | Lettered options (A/B/C), the recommended one first as A. Each option states what happened, what the choice does, and what the human must do. |
| `[HUMAN]` | A step only the human can run. | Give the exact command or action. |

Destructive, shared-state, low-confidence, or out-of-scope actions are never
`[DONE]`.

Two rules keep `[WAIT]` honest. The recommendation goes first, as A, so the reader
meets the default before the alternatives. And if you cannot justify it in one
clause — "recommended because X" — then you do not have a recommendation: label the
block `(no recommendation — your call)` and say why the choice is genuinely human.
Marking A by reflex defeats the point of asking. Options must also be mutually
exclusive, and when doing nothing is a legitimate path it gets its own letter
rather than being left implicit.

## Example

```
## NEXT ACTION [WAIT]

The migration passed against staging, but it rewrites `orders.status` in place,
so the production run is not reversible.

A) Ship it behind the dual-write flag first (recommended)
- Recommended because it makes a bad deploy a flag flip instead of a restore.
- Command: ./deploy --flag dual_write_orders
- Keeps the old column readable for one release. You deploy; I watch the first
  batch and report row counts.

B) Run the destructive migration now
- Command: make migrate-prod
- One less release to wait for, but recovery means a point-in-time restore. You
  run it, since it needs the production credential.

C) Do nothing this week
- Nothing to run. The current code path keeps working; I go finish the backfill
  audit and re-open this decision with real numbers.
```

## Referencing a PR or issue (optional)

If you work across more than one repository, add the second section of
[`PROTOCOL.md`](PROTOCOL.md) too. It bans the bare `#64` — numbers are
per-repository, so a bare one identifies nothing once several repos or checkouts
are in play — and requires every reference to carry `owner/repo`, a full link, and
a command with `--repo owner/repo` spelled out. If you only ever work in one repo,
stay with the three tags.

## Install

**OMP** — copy or link `omp/next-action.md` into the `agent/rules/` directory of
your OMP configuration. It already carries `alwaysApply: true`, so it loads into
every session.

**Other harnesses (Claude Code, Cursor, AGENTS.md)** — paste the contents of
[`PROTOCOL.md`](PROTOCOL.md) into whichever instruction file is always loaded:
`CLAUDE.md`, a file under `.cursor/rules/`, `AGENTS.md`, or the system prompt
itself. `PROTOCOL.md` has no frontmatter and no harness-specific syntax, so it
drops in as-is.

## License

MIT. See [LICENSE](LICENSE).
