# NEXT ACTION protocol

A coding agent that ends with "let me know how you'd like to proceed" has handed
the work back without saying what the work is. This protocol fixes that: every
recommendation-bearing response ends with exactly one unambiguous action, and when
the decision belongs to the human, the options are spelled out instead of implied.

Four tags, exactly one per response:

| Tag | Meaning | Requirement |
| --- | --- | --- |
| `[DONE]` | The agent already executed it. | Auto-apply only when all three hold: reversible, scoped to the task, confidence >= 0.8. |
| `[DECIDE]` | A choice only the human can make. | Lettered options (A/B/C), the recommended one first as A. Each option states what happened, what the choice does, and what the human must do. |
| `[HUMAN]` | A step only the human can run. | Give the exact command or action. |
| `[WAIT]` | Blocked on something external that resolves on its own. | Name what you are waiting on, how you will know it finished, and the fallback if it never does. Nothing for the human to do. |

Destructive, shared-state, low-confidence, or out-of-scope actions are never
`[DONE]`. And the work is not finished until a response ends in `[DONE]` — every
other tag means the loop is still open.

Two rules keep `[DECIDE]` honest. The recommendation goes first, as A, so the
reader meets the default before the alternatives. And if you cannot justify it in
one clause — "recommended because X" — then you do not have a recommendation: put
`(no recommendation — your call)` on the tag line and say why the choice is
genuinely human. Marking A by reflex defeats the point of asking. Options must also
be mutually exclusive, and when doing nothing is a legitimate path it gets its own
letter rather than being left implicit.

## Example

```
## NEXT ACTION [DECIDE]

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

## Migrating from the 3-tag version

`[WAIT]` changed meaning, not just spelling. Earlier versions used it for "your
decision", which read as "the agent is waiting on a background job" to everyone who
met it cold. The name now says what it looks like it says:

| Then | Now |
| --- | --- |
| `[WAIT]` meaning "your decision" | Rename to `[DECIDE]` |
| — | `[WAIT]` now means an external blocker that resolves on its own; nothing for the human to do |

So if you already run the 3-tag version, rename every decision-shaped `[WAIT]` to
`[DECIDE]`, and keep `[WAIT]` only for CI runs, background jobs, other agents, and
timers.

## Referencing a PR or issue (optional)

If you work across more than one repository, add the second section of
[`PROTOCOL.md`](PROTOCOL.md) too. It bans the bare `#64` — numbers are
per-repository, so a bare one identifies nothing once several repos or checkouts
are in play — and requires every reference to carry `owner/repo`, a full link, and
a command with `--repo owner/repo` spelled out. If you only ever work in one repo,
stay with the four tags.

## Install

Pick the surface your harness loads on EVERY response. A protocol that shapes
every answer is worthless on a surface that only loads when something matches a
description.

### Claude Code

Always-loaded. `CLAUDE.md` is read into context on every response — user-level
(`~/.claude/CLAUDE.md`, applies to every project) or project-level (`./CLAUDE.md`,
committed with the repo).

```sh
mkdir -p ~/.claude && cat claude/CLAUDE.md >> ~/.claude/CLAUDE.md   # all projects
cat claude/CLAUDE.md >> ./CLAUDE.md                                 # this repo only
```

Do NOT install this as a Claude Code skill. Skills load on demand, selected by
their `description` — a skill would apply to some responses and not others, which
is exactly the failure mode this protocol exists to prevent.

### OMP

Always-loaded. A rule with `alwaysApply: true` enters every session.

```sh
cp omp/next-action.md <your-omp-config>/agent/rules/next-action.md
```

The file already carries the `alwaysApply: true` frontmatter, so there is nothing
else to set.

### Any harness with an always-loaded instructions file

Append [`PROTOCOL.md`](PROTOCOL.md) to whichever file your harness always loads —
`AGENTS.md`, `.cursorrules`, a file under `.cursor/rules/`, or the system prompt
itself. `PROTOCOL.md` has no frontmatter and no harness-specific syntax, so it
drops in as-is:

```sh
cat PROTOCOL.md >> ./AGENTS.md
```

If the only surface available is on-demand (a skill, a slash command, a
description-matched rule), the protocol will not hold. Use a fixed-context file
instead.

## License

MIT. See [LICENSE](LICENSE).
