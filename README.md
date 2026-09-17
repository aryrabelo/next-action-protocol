# NEXT ACTION protocol

A coding agent that ends with "let me know how you'd like to proceed" has handed
the work back without saying what the work is. This protocol removes that: every
recommendation-bearing response ends in exactly one unambiguous action, and the
options are spelled out whenever the decision is the human's.

Four tags, exactly one per response:

| Tag | Meaning | Requirement |
| --- | --- | --- |
| `[DONE]` | The agent already executed it. | Only when all three hold: reversible, scoped to the task, confidence >= 0.8. |
| `[DECIDE]` | A choice only the human can make. | Lettered options (A/B/C), the recommended one first as A. Each states what happened, what the choice does, and what the human must do. |
| `[HUMAN]` | A step only the human can run. | Give the exact command or action. |
| `[WAIT]` | Blocked on something external that resolves on its own. | Name what you are waiting on, how you will know it finished, and the fallback if it never does. Nothing for the human to do. |

Destructive, shared-state, low-confidence, or out-of-scope actions are never
`[DONE]`. The work is not finished until a response ends in `[DONE]`.

## Example

```
## NEXT ACTION [DECIDE]

The migration passed against staging, but it rewrites `orders.status` in place,
so the production run is not reversible.

A) Ship it behind the dual-write flag first (recommended)
- Recommended because it makes a bad deploy a flag flip instead of a restore.
- Command: ./deploy --flag dual_write_orders
- You deploy; I watch the first batch and report row counts.

B) Run the destructive migration now
- Command: make migrate-prod
- Recovery means a point-in-time restore. You run it; it needs the credential.

C) Do nothing this week
- Nothing to run. I finish the backfill audit and re-open this with real numbers.
```

## Install

| Path | When it loads | Guarantee |
| --- | --- | --- |
| `SKILL.md` via `npx skills add` | ON DEMAND — the agent decides from the description | Partial. Maximum reach, no guarantee it is loaded on the response that matters. |
| Always-loaded file | EVERY response | Full. This is the reliable mode, and the recommended one. |

```sh
npx skills add aryrabelo/next-action-protocol --agent claude-code -g
```

Good for trying it out, and for agents with no always-loaded file; if you like it,
move to the fixed one. `next-action.md` is the portable text, no frontmatter:

```sh
cat next-action.md >> ~/.claude/CLAUDE.md   # Claude Code, every project
cat next-action.md >> ./CLAUDE.md           # Claude Code, this project only
cat next-action.md >> ./AGENTS.md           # or .cursorrules, or the system prompt
```

For OMP, copy `omp/next-action.md` into the `agent/rules/` directory of your
config: same text plus `alwaysApply: true`, so there is nothing else to set.

Warning if you manage `~/.claude` or `~/.omp` declaratively (nix, home-manager):
`npx skills add` creates a real directory in the agent's skills path and collides
with the generation that owns it, so activation fails with "destination exists and
is not our symlink". Use the always-loaded file instead.

## Migrating from the 3-tag version

`[WAIT]` changed meaning, not just spelling.

| Then | Now |
| --- | --- |
| `[WAIT]` meaning "your decision" | Rename to `[DECIDE]` |
| — | `[WAIT]` is now an external blocker that resolves on its own; nothing for the human to do |

## License

MIT. See [LICENSE](LICENSE).
