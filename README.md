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

## Copy and paste this

No install step. Paste this block at the end of the file your agent always loads
— `CLAUDE.md` for Claude Code, `AGENTS.md` for Codex, Cursor, Gemini CLI, Amp and
most others, or the system prompt if that is all you get:

````markdown
# NEXT ACTION protocol

End every recommendation-bearing response with a `## NEXT ACTION` heading, then a
blank line, then exactly one tag on its own line:

- `[DONE]` — you already executed it. Auto-apply ONLY when all three hold: reversible, scoped to the task, confidence >= 0.8.
- `[DECIDE]` — a choice only the human can make. Lettered options (A/B/C); the recommended one is listed FIRST, as A. Each option states what happened, what the choice does, and what the human must do. If you cannot justify the recommendation in one clause, write `(no recommendation — your call)` on the tag line and give the one-line reason the choice is genuinely human. Options are mutually exclusive, and when "do nothing" is a legitimate path it is a lettered option, never implicit.
- `[HUMAN]` — a step only the human can run; give the exact command or action.
- `[WAIT]` — you are blocked on something external that resolves on its own (background job, CI run, another agent, a timer). Name what you are waiting on, how you will know it finished, and the fallback if it never does. Nothing for the human to do here. A decision is NEVER `[WAIT]` — that is `[DECIDE]`.

Destructive, shared-state, low-confidence, or out-of-scope actions are never `[DONE]`.

Exactly one tag per response. The work is not finished until a response ends in
`[DONE]` — every other tag means the loop is still open.

```
## NEXT ACTION

[DECIDE] — <one line framing the choice>
```
````

That is the whole protocol. Nothing else to configure, and it works on any agent
that reads an instruction file.

## Em português

O mesmo texto em português está em `pt/next-action.md`. O heading e as tags
continuam em inglês de propósito: são os tokens do protocolo, não prosa.

````markdown
# Protocolo NEXT ACTION

Termine toda resposta que carrega uma recomendação com um heading `## NEXT ACTION`,
depois uma linha em branco, depois exatamente uma tag sozinha na linha:

- `[DONE]` — você já executou. Aplique por conta própria APENAS quando as três valerem: reversível, dentro do escopo da tarefa, confiança >= 0,8.
- `[DECIDE]` — uma escolha que só o humano pode fazer. Opções em letras (A/B/C); a recomendada vem PRIMEIRO, como A. Cada opção diz o que aconteceu, o que a escolha faz e o que o humano precisa fazer. Se você não consegue justificar a recomendação em uma oração, escreva `(sem recomendação — decisão sua)` na linha da tag e dê em uma linha o motivo de a escolha ser genuinamente humana. As opções são mutuamente exclusivas e, quando "não fazer nada" é um caminho legítimo, ele é uma opção com letra, nunca implícito.
- `[HUMAN]` — um passo que só o humano pode rodar; dê o comando ou a ação exata.
- `[WAIT]` — você está bloqueado por algo externo que se resolve sozinho (job em background, execução de CI, outro agente, um timer). Diga o que você está esperando, como vai saber que terminou e qual é o fallback se nunca terminar. Aqui não há nada para o humano fazer. Uma decisão NUNCA é `[WAIT]` — isso é `[DECIDE]`.

Ação destrutiva, de estado compartilhado, de baixa confiança ou fora do escopo nunca é `[DONE]`.

Exatamente uma tag por resposta. O trabalho não terminou até uma resposta terminar
em `[DONE]` — qualquer outra tag significa que o loop continua aberto.

O heading e as tags ficam em inglês de propósito: são os tokens do protocolo, não
prosa. Nunca traduza `## NEXT ACTION`, `[DONE]`, `[DECIDE]`, `[HUMAN]` ou `[WAIT]`.

```
## NEXT ACTION

[DECIDE] — <uma linha enquadrando a escolha>
```
````

```sh
cat pt/next-action.md >> ~/.claude/CLAUDE.md   # Claude Code, todo projeto
cat pt/next-action.md >> ./AGENTS.md           # ou .cursorrules, ou o system prompt
```

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
- Recovery means a point-in-time restore. You run it; it needs the credential.

C) Do nothing this week
- Nothing to run. I finish the backfill audit and re-open this with real numbers.
```

## The same text, as a file

`next-action.md` is the block above with no frontmatter, plus one optional section
on referencing pull requests and issues when the work spans several repositories:

```sh
cat next-action.md >> ~/.claude/CLAUDE.md   # Claude Code, every project
cat next-action.md >> ./CLAUDE.md           # Claude Code, this project only
cat next-action.md >> ./AGENTS.md           # or .cursorrules, or the system prompt
```

For OMP, copy `omp/next-action.md` into the `agent/rules/` directory of your
config: same text plus `alwaysApply: true`, so there is nothing else to set.

## Or install it as a skill

| Path | When it loads | Guarantee |
| --- | --- | --- |
| `SKILL.md` via `npx skills add` | ON DEMAND — the agent decides from the description | Partial. Maximum reach, no guarantee it is loaded on the response that matters. |
| Always-loaded file | EVERY response | Full. This is the reliable mode, and the recommended one. |

```sh
npx skills add aryrabelo/next-action-protocol --agent claude-code -g
```

Good for trying it out, and for agents with no always-loaded file; if you like it,
move to the fixed one.

Warning if you manage `~/.claude` or `~/.omp` declaratively (nix, home-manager):
`npx skills add` creates a real directory in the agent's skills path and collides
with the generation that owns it, so activation fails with "destination exists and
is not our symlink". Use the always-loaded file instead.

## License

MIT. See [LICENSE](LICENSE).
