---
title: 08-text-fences
---
# `08-text-fences/` — the artifact your script carries

Files in this chapter (each opens on GitHub; the transcript beside a program is what `check.sh` diffs against):

{% assign dir = page.dir %}{% for f in site.static_files %}{% if f.path contains dir %}- [`{{ f.name }}`](https://github.com/bashsharp/tour/blob/main{{ f.path }})
{% endif %}{% endfor %}

Every case here runs on the binary alone (`needs -`). The rows that need a
tool bashy provisions, or a container engine, are the next chapter,
[`09-fences-advanced/`](../09-fences-advanced/).

## What a text fence is

`04-islands` fenced *code*: the alias exposes the functions the language's
analyzer finds in the body. A **text fence** carries an *artifact* — a
config, a dag, a skill, a Dockerfile, an OpenTofu module — and the alias
exposes the verbs of its **processor**:

```
~~~<type> [as <alias>] [!<runner>]
```

- The methods are **declared, never guessed.** A built-in row (`dag`,
  `skill`, `dockerfile`, `tf`, `k8s`, `helm`) answers from its table; a
  `!runner` is asked once, at prepare, with `runner methods <file>` and
  answers one JSON object per line (`{"name":…, "effects":[…]}`). That list
  *is* the alias — `alias.<undeclared>()` is a prepare-time error, an empty
  answer is a refusal, and the format is never detected from the body.
- **Every verb carries its effects.** `apply` says `write`, a dag target's
  `Effects:` line is its method's effect, `run` on a skill is `exec`. A
  `@guard` that does not allow the effect denies the call with status
  **126** *before* the processor runs, and binds the zero value so a `:=`
  site stays well-formed — the same boundary `@effects` gives a function
  (`06-sharp`).
- **A runner is never found on `PATH`.** `!name` resolves to a function of
  this unit, then to a registered command (`07-commands`), then is refused.
  Wrapping a program in a function is the deliberate escape hatch.
- **The body never lands in your tree.** It materializes under bashy's cache,
  keyed by the plan; a runner that writes (`runner.bsh`'s `apply`) writes
  beside it.

| case | fence | what it shows |
|---|---|---|
| `runner.bsh` | `~~~env as cfg !env-runner` | a shell function as the processor: `methods`, `show`, `apply` (`write`) — and the guard denial |
| `dag.bsh` | `~~~dag as ci` | a script carrying its own pipeline; targets are methods; a target's `Effects:` is capped |
| `skill.bsh` | `~~~skill as s` | a SKILL.md as the one skill of a private ring: `verify`, `probe`; `run` (`exec`) rehearsed under a read cap |
| `registered.bsh` + `words.bsh` | `~~~awk as aw !awk-runner` | a language with no fence, through a runner registered once as a command; the refusal before registration |

## What lowers

`bashy transpile` turns a Bash# program into Go, and the rule is that **a
transpiled binary never depends on a shell on the target**. So of the runner
shapes above, only a Bash# `func` with the runner signature —
`func NAME(verb string, file string, args ...string) string` — is accepted by
`transpile` (`09-fences-advanced/builder.bsh` is one). A shell function
(`runner.bsh`), a registered command (`registered.bsh`) and the `dag` /
`skill` rows run in the interpreter, and `transpile` refuses them **by
name, with the route**: declare the runner as a Bash# `func` and it lowers.
The decision record is
[`lowered-runner-fences.md`](https://github.com/bashsharp/bashsharp/blob/main/docs/lowered-runner-fences.md);
the fence itself is decided in
[`fenced-text-blocks-plan.md`](https://github.com/bashsharp/bashsharp/blob/main/docs/fenced-text-blocks-plan.md).

[← back to the tour](../)
