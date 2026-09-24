---
title: 09-fences-advanced
---
# `09-fences-advanced/` — the rod, engines, manifests

Files in this chapter (each opens on GitHub; the transcript beside a program is what `check.sh` diffs against):

{% assign dir = page.dir %}{% for f in site.static_files %}{% if f.path contains dir %}- [`{{ f.name }}`](https://github.com/bashsharp/tour/blob/main{{ f.path }})
{% endif %}{% endfor %}

Part 2 of the fences chapters. [`08-text-fences/`](../08-text-fences/)
runs on the binary alone; every case here **needs** something — a toolchain
bashy provisions on first use (as the islands do, from a pinned,
checksum-verified release, never from your `PATH`), or a running container
engine.

| case | fence | needs | what it shows |
|---|---|---|---|
| `builder.bsh` | `~~~zig as z !builder` | cc | **the rod, compiler shape**: a language with no fence, compiled by a toolchain bashy already has (`bashy zig`, the C islands' compiler), through an inline Bash# `func` runner — the one runner shape `bashy transpile` accepts |
| `dockerfile.bsh` | `~~~dockerfile as img` | podman | `build` → an image id (net, write), `run` (exec); `build` denied under a read cap |
| `k8s.bsh` | `~~~k8s as app` | podman | a manifest played locally (`play` / `down` through podman kube); `down` (destroy) denied under an exec cap; `apply` / `delete` / `get` / `diff` are the cluster verbs, `remote`, not exercised here |
| `manifests/pyproject/` | `~~~pyproject as py` | python3 | a script carrying its `pyproject.toml` with a dependency; `run` |
| `manifests/gomod/` | `~~~gomod as mod` + `~~~go` | go | the manifest fence is the code fence's module; `tidy`, `run` |
| `manifests/makefile/` | `~~~makefile as mk` | - | bashy's in-process POSIX make: `build`, `test`, `target(name)` |
| `manifests/package/` | `~~~package as npm` | typescript | a script carrying its `package.json`; `build`, `test`; `$INIT_CWD` is where you were |

Three rows are not in this chapter yet, on purpose: `tf` (OpenTofu), and
the `cargo` and `cmake` manifests. Their cases exist and pass on a machine
with a host linker and an unthrottled GitHub API — which is exactly what
the install matrix is not: on a stripped `PATH` the `cargo` row finds no
linker and the `cmake` row no compiler or make program (the islands carry
their own; these rows do not yet), and the `tofu` provisioner asks the
GitHub API for "latest" instead of a pinned release and is rate-limited on
shared runners. The tour never marks a case that fails *by which machine
it runs on* as known-failing, so the three wait for the fixes in bashy
(cards `4995ee3e`, `18f7a7aa`, `dd498d73`).

## Manifest fences

A script carries its project manifest inline and drives the toolchain's
verbs — each with its declared effects — from **the directory it is run
in**. Two rules, both visible in the transcripts:

- **Nothing is written into your tree.** The manifest, the dependency caches
  and the build outputs live under bashy's cache; `git status` in a case's
  directory sees nothing after a run. A tool that insists the manifest sit
  beside the sources (cargo, npm) gets a *shadow project* with your sources
  linked in; one that can take the manifest from elsewhere (`uv --project`,
  `make -f`, `cmake -S`, `go -overlay`) is pointed at it.
- **The directory is the caller's.** Each case `cd`s to its own directory
  first so it runs from anywhere; from a shell you would say
  `bashy awd 09-fences-advanced/manifests/gomod -- bashy --bashsharp build.bsh`.

The type names the *manifest*, never the language: `~~~gomod` is a module,
`~~~go` is code, and a script may carry both.

## The engine cases on the matrix

`dockerfile.bsh` and `k8s.bsh` need a running engine (`bashy podman info`).
GitHub's Linux runner has one; its macOS and Windows runners do not, so
`cases.tsv` marks the two cases **known-failing on the darwin and windows CI
legs** (`ci:` markers, applied under GitHub Actions only) with one card, their transcripts are pinned from Linux, and an unexpected pass
on those legs fails the gate so the marker cannot rot. On your own Mac or
Windows box with `bashy podman machine start` done, both cases pass with
the same transcript. `needs` is never a reason to skip; a case that cannot
reach its processor is a *recorded* failure, not a silent one.

## What lowers

`builder.bsh` is the shape `bashy transpile` accepts: a Bash# `func` with
the runner signature (`func NAME(verb string, file string, args ...string)
string`) is emitted as Go and called directly (the byte-identical
interpreted/lowered parity proof is a test in the language repo; a lowered
program carries no effect cap yet, so the 126 denial is the interpreter's). The built-in rows
(`dockerfile`, `k8s`, the manifests) lower with their body embedded;
`dag` and `skill` and every other runner shape are interpreter-only and
refused by name — see
[`lowered-runner-fences.md`](https://github.com/bashsharp/bashsharp/blob/main/docs/lowered-runner-fences.md).
The rows themselves are decided in
[`fenced-text-blocks-plan.md`](https://github.com/bashsharp/bashsharp/blob/main/docs/fenced-text-blocks-plan.md)
(§Manifest fences, §Rod vs fish).

[← back to the tour](../)
