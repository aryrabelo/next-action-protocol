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

## Referenciando um PR ou issue

Opcional. Pule esta seção se você só trabalha em um repositório.

NUNCA um `#64` solto. Números são por repositório, então assim que você trabalha em
vários repos — ou em vários checkouts do mesmo repo — um número solto não identifica
nada e custa uma ida e volta para resolver.

Toda referência a pull request ou issue vem qualificada por `owner/repo`. Qualquer
opção que aponte para uma delas carrega pelo menos estas linhas:

```
A) <o que a escolha faz> (recomendada)
- Link: https://github.com/<owner>/<repo>/pull/<N>
- Comando: <o comando exato, com --repo <owner>/<repo> escrito>
```

O link é a identidade sem ambiguidade; o comando nomeia o repo explicitamente para
que colá-lo de qualquer diretório atinja o repo certo, em vez de resolver contra o
que estiver por acaso no checkout.

Se o seu harness tem um esquema de URI próprio para pulls e issues, adicione essa
linha também, na forma totalmente qualificada `owner/repo/<N>`.

Mesma regra para qualquer coisa já fechada que você mencione como referência: linke.
