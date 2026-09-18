# Bash# in ten minutes

Bash# is **alpha**. Everything in this directory runs today on a released
`bashy`; nothing here needs a model, an API key, a network, or a Go toolchain.
Syntax may still change before 1.0 — the way to influence it is an RFC in
the language repo.

## Install

See [Install bashy](../README.md#install-bashy-two-minutes) — one static
binary per platform. Then `bashy --version`.

## Run the demo

```sh
bashy --bashsharp judge.bsh
```

`judge.bsh` is one `agentic` function under three deterministic contracts:

| call | what happens | exit |
|---|---|---|
| `summarize ok` | require passes → body runs → ensure passes | **0** |
| `summarize ""` | `@require` fails; the body never runs | **3** |
| `summarize lie` | body runs and exits 0; `@ensure` disagrees | **3** |
| `summarize write` | body tries to write under `@guard(effects: "read")` | **1** (denied) |
| `summarize fail` | body returns 1 | **1** |
| `summarize yield` | body returns 6 — *input required* — no ensure runs | **6** (a yield) |

Exit 6 is the interesting one: the interpreter never calls a model. An
`agentic` body that needs something it does not have *yields* to whoever is
running the script — your shell, or the coding agent that ran `bashy -c` —
so the agent can ask, and retry. The same `@ensure` then guards a typed Go
function in the same file (`twice`).

`judge.expected` is the pinned transcript (first line = the exit status);
`../check.sh` from the repo root diffs it, and every other file in the tour,
against the `bashy` on your `PATH`.

Next: [`../01-bash/`](../01-bash/), or the chapter list in the
[top-level README](../README.md#the-six-ideas).

## What Bash# is

The bash you already know (every Bash 5.3 script means the same thing; with
the flag off the dialect is inert), Go where you need types, any fenced
language where you need a library, and `agentic` where you need a model —
with contracts so a model's output is judged, never trusted.

Every number about Bash# names its corpus, and lives in the language repo's
`docs/claims.md`.
