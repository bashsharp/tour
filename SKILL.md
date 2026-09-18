---
name: bashsharp-tour
description: >-
  Walk a person through the Bash# language tour on their installed bashy —
  27 small programs in six chapters (bash-is-bash, POSIX, Go mixed, fenced
  islands, agentic + contracts, the Sharp ergonomics tier), each with a
  pinned transcript, and one gate (check.sh) that proves every one on the
  binary in front of you. Use when asked to learn, teach, demonstrate or
  verify Bash#, and keep it loaded whenever you write Bash# afterwards: the
  chapters are the only syntax shapes you may copy. NOT a language
  reference — a construct that is not in a chapter is not promised here.
metadata:
  check-tour: ./check.sh
  check-one: bashy --bashsharp <chapter>/<file>.bsh
  check-pin: ./check.sh --pin
---

# Bash# tour — agent procedure

You are driving a tour for a **person who is learning**. Two things follow.
The transcripts (`*.expected`) are the contract — a chapter is understood
when the run matches its transcript byte for byte and status for status.
And the person sets the pace — you show, run, explain, and **wait**.

## Preconditions

1. `bashy --version` prints a version. If not, point the person at the
   README's *Install bashy* section for their OS; do not build from source.
2. Work from the repo root; every path below is relative to it.
3. A `bashy` older than the rename may not know `--bashsharp`. If
   `bashy --bashsharp 01-bash/bash-is-bash.bsh` fails with an unknown option,
   `export BASHSHARP_FLAG=--bashpp` and read every `--bashsharp` below as
   that flag.

## Working with the person

- **Start by running the gate and reading its last line aloud**:
  `./check.sh` (on Windows: `bashy ./check.sh`) → `tour: N passed, 0 failed, M skipped (…version…)`. Explain
  each SKIP in one sentence (it names a tool that is not installed and the
  chapter it affects). If anything FAILs, stop here: show the diff, and
  offer to file it — do not continue the tour on a binary that disagrees
  with its transcripts, and never edit an `.expected` file to make it pass.
- **One file at a time.** For each: `cat` it (the comment at the top says
  what to notice), run it, show the transcript, then explain the difference
  between what a plain bash user would expect and what happened. Then
  **ask whether to continue** before the next file. Do not batch chapters.
- **Answer from the transcript, not from memory.** If asked *why* something
  exits 3, run it and point at the line. If asked something the tour does
  not cover, say so and offer the language repo's docs rather than guessing.
- **Encourage breaking things.** When the person asks "what if…", make the
  edit in a scratch copy (`cp file /tmp/x.bsh`), run it, and show the
  diagnostic. The diagnostics are the language explaining itself.
- **Match the person's level.** New to programming: chapters 00, 01, 02, 05
  are the story; skip 03/04/06 unless asked. Knows bash: dwell on 01, 02, 06
  and the "with the dialect off" run. Knows Go: dwell on 03 and the
  `--source=go` whole program, then 05.
- **End with the report** (below), whether or not you finished.

## The chapters, in order

| chapter | run | what to point at |
|---|---|---|
| `00-quickstart/judge.bsh` | `bashy --bashsharp 00-quickstart/judge.bsh` | six calls, six exit codes **0 3 3 1 1 6**; `6` is a *yield* |
| `01-bash/bash-is-bash.bsh` | run with `--bashsharp` AND with `--no-bashsharp` | identical — a Bash 5.3 script means the same thing either way |
| `02-posix/posix-script.sh` | `bashy --posix 02-posix/posix-script.sh` | POSIX through the same engine and the pure-Go coreutils |
| `02-posix/dialect-is-inert.bsh` | `bashy --posix 02-posix/dialect-is-inert.bsh` | `x: command not found` — under `--posix` the dialect does not exist |
| `03-go/01-values.bsh` | `bashy --bashsharp …` | `:=`, a typed `func`, a call as a WORD; `"$x"` expands a Go value as text |
| `03-go/02-funcs.bsh` | `bashy --bashsharp …` | `if`/`switch`/`for`/`return` inside a func body (top-level Go `if {` in shell text is planned, not shipped) |
| `03-go/03-whole-program.go` | `bashy --bashsharp --source=go 03-go/03-whole-program.go` | a whole Go 1.27 program with generics; where the corpus numbers are measured |
| `03-go/04-transpile.bsh` | run it; then `bashy transpile --bashsharp 03-go/04-transpile.bsh -o /tmp/t.go` and `cat /tmp/t.go` | ordinary Go comes out; building it needs go ≥ 1.27 and the engine's `shellrt` (see README) |
| `04-islands/*.bsh` (`go/go.bsh` sits next to its `go.mod`) | `bashy --bashsharp 04-islands/python.bsh` etc. | a fenced block becomes callables; each language runs on the person's own compiler — SKIP the ones the gate skipped |
| `05-agentic/01-scope.bsh` | `bashy --bashsharp …` | calling an agentic action OUTSIDE an `agentic { }` scope is refused (exit 1); inside, it runs |
| `05-agentic/02-forms.bsh` | `bashy --bashsharp …` | the spellings: `agentic function`, typed `agentic func`, a typed method, the `agentic { }` scope |
| `05-agentic/03-contracts.bsh` | `bashy --bashsharp …` | `@require` before (fail → 3, body never runs), `@ensure` after (fail → 3), `$RESULT`, checks don't leak |
| `05-agentic/04-judge.bsh` | `bashy --bashsharp …` | the quickstart again, now that the pieces are known |
| `05-agentic/05-yield.bsh` | `bashy --bashsharp …; echo $?` | status **6** = input required; no `@ensure` on a yield; `\|\| exit $?` hands the 6 to the caller — the script itself exits 6 |
| `06-sharp/01-decorators.bsh` | `bashy --bashsharp …` | `@tag(...)` over a `func`; `c *Call`, `c.Next()`; arguments re-evaluated per call (`late-a`, `late-b`) |
| `06-sharp/02-kwargs-defaults.bsh` | `bashy --bashsharp …` | defaults, positional, keywords in any order |
| `06-sharp/03-enums.bsh` | `bashy --bashsharp …` | every member covered; delete one to see `BASHPP-EENUM-NONEXHAUSTIVE` |
| `06-sharp/04-readonly.bsh` | `bashy --bashsharp …` | reads through an alias; a write in a subshell refused; value unchanged |
| `06-sharp/05-null-safety.bsh` | `bashy check --bashsharp 06-sharp/05-null-safety.bsh; echo $?` | `BASHPP-ENULL-DEREF`, exit 2; it is a CHECK, not syntax |

The mode, needs and expected status of every file are in `cases.tsv`; that
file is what `check.sh` reads.

## Rules when you write Bash# for the person afterwards

- **Copy shapes from the chapters.** Bash# admits a construct only at a
  measured start site; a shape not in a chapter may parse as plain bash and
  silently do something else. Three you will reach for that are NOT here:
  a top-level Go `if x != 0 { … }` block in shell text (planned — put it in
  a `func`); a call in keyword-argument position (`greet(retries: twice(2))`
  — bind to a name first, as `03-go/04-transpile.bsh` does); a negative
  literal as a call argument (`f(-3)` — bind it first).
- **Never write a tilde fence inside a comment**; the island scanner takes
  it for a real one.
- **`agentic` is a boundary, not a feature.** Only put in an `agentic` body
  what genuinely needs a model; call it only from an `agentic { }` scope;
  put a `@require`/`@ensure` on it; treat status 6 as "ask the person".
- **Every number about Bash# names its corpus** — the language repo's
  `docs/claims.md`. Do not quote others, and do not say "100%".
- Single-quote a contract check; double quotes expand at the decorator line.
- With the dialect off (`--no-bashsharp`, `--posix`, the `bash` binary) none
  of this exists — that is the compatibility guarantee.

## What is known-failing, and why you do not "fix" it

On Windows the gate may print `XFAIL` for the Python, Rust, C and C++
islands with a card id: the toolchain is present but bashy cannot drive it
there yet (Store `python3` alias, `link` applet shadowing MSVC's linker,
clang without SDK includes). Tell the person it is a known, tracked
limitation of the release, not of their machine, and move on. Do not edit
`cases.tsv` to make the count look better; an unexpected PASS there fails
the gate on purpose so the marker is removed with the fix.

## Report

When the person asks how it went, or the tour ends, give exactly:

1. the gate's summary line, verbatim;
2. each SKIP with its reason;
3. each FAIL with its unified diff, verbatim — never paraphrased;
4. the `bashy --version` line;
5. the chapters the person actually walked, and the questions they asked
   that the tour could not answer (those become issues or RFCs).
