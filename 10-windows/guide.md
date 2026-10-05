# Bash# first: a Windows user's front door

**Bash# is the preferred language for authoring agentic workflows, and
bashy is the system that runs them — on Windows, Linux and macOS alike.**
This guide takes Windows without PowerShell 7 to a running `.bsh` workflow that
calls familiar PowerShell and C# code, then carries the same file to Linux
and macOS for the same result.

Bash# and bashy have their own interface. They are not an imitation of
Linux, macOS or Windows, nor of any one shell: the goal is that users from
all three OSes feel at home in the same workflow. PowerShell and C# join
that workflow as *fenced islands* — places where existing code and
libraries are invoked — not as a parallel shell, pipeline or orchestration
layer.

## 1. Start clean

On a Windows machine with no PowerShell 7 installed, system .NET may
coexist. Windows includes .NET Framework, which is separate from the modern
.NET runtime packaged with PowerShell 7. Bashy uses its pinned guest runtime
for both fences and does not require or select the system installation.
See [Microsoft's Windows/.NET requirements](https://learn.microsoft.com/en-us/dotnet/framework/get-started/system-requirements)
for the in-box Framework baseline.

1. Copy a Sprint 358-capable `bashy` binary to the machine (the build must
   include `bashy` commit `536e8256f` or later and the Sprint 358 `sh`
   pin). No PowerShell 7, .NET SDK or guest toolchain setup is needed.
   The current `v0.31.0` release predates these fences; use a verified
   Sprint 358 build until a milestone release includes them.
2. Save [`workflow.bsh`](workflow.bsh) beside this guide.
3. Run it:
   ```sh
   bashy --bashsharp workflow.bsh
   ```
4. The first run provisions the guest runtime itself: bashy downloads the
   pinned PowerShell 7.6.6 archive for your platform, verifies its digest
   against the pin in its own source, and caches it under your user cache
   directory. A toolchain you happen to have installed is never consulted.
   Pay that download once with `bashy check --prepare workflow.bsh`
   (a no-op afterwards, and the way to warm a CI image or an air-gapped box).

Expected output — byte for byte, on every OS:

```
== report ==
total=42
seq=1-2-3
FENCES TRAVEL!
[alpha]
[beta]
[gamma]
total checks out
```

## 2. Carry it to Linux and macOS

Copy the same `workflow.bsh` to a Linux or macOS machine with bashy
installed and run the same command. Nothing changes: no path edits, no
`if windows` branches. Two mechanisms keep the bytes identical:

- Text the fences write to stdout and stderr is normalized to `\n` on every
  OS; only a `byte[]` result passes through untouched.
- The shell pipe stays a byte pipe. PowerShell's object pipeline does not
  cross the fence: structured values cross once, at the call edge, as a
  Bash# `Object`.

## 3. Who owns what in `workflow.bsh`

The `.bsh` program owns control flow, data exchange and contracts:

- `if test "$total" -eq 42; then … fi` — Bash# decides.
- `printf … | ps.Bracket | sort` — the Bash# pipe moves bytes.
- `@ensure('test -n "$RESULT"')` on `headline` — the same contract idiom as
  `05-agentic/03-contracts.bsh`: it judges the result, and no model is
  called to produce it. Bash# is the forward path for agentic tools;
  contracts, the `agentic` boundary and orchestration stay in the `.bsh`
  program on every OS.

The fences are called only where their language is useful: PowerShell
shapes text the Windows way, C# computes with a .NET library.

## 4. The fence boundary, idiom by idiom

### PowerShell (`~~~powershell`, aliases `~~~pwsh`, `~~~ps1`)

```powershell
function Shout([string]$s) {
  return $s.ToUpper() + "!"
}
function Bracket {
  process { "[$_]" }
}
```

- The opener may take an alias: `~~~powershell as ps`. Public functions of
  an unaliased block are bare Bash# calls; an aliased block qualifies them
  (`ps.Shout(...)`).
- **Exported-call convention.** A function with typed parameters is a typed
  call: `[string]` takes a Bash# string, `[long]` an int, `[double]` a
  float, `[bool]` a bool, `[byte[]]` bytes. A function with no declared
  return type is dynamic: bind both results, `shouted, serr :=
  ps.Shout("fences travel")`, exactly like the TypeScript island's
  `answer, err := ts.sum(…)`.
- **Pipes.** An exported function is also a command word. A function that
  reads pipeline input — a `process` block, a `$input` reference, or a
  `ValueFromPipeline` parameter — runs as a filter over the command's
  stdin, one line per item; any other function never reads stdin. The shell
  pipe stays bytes.
- **Errors.** A terminating error or an uncaught `throw` is the call's
  error (`err` in a typed call; exit status `1` with the message on stderr
  in command form). Non-terminating errors (`Write-Error`) go to stderr and
  do not fail the call. Bash# does not adopt `$ErrorActionPreference`,
  `ExecutionPolicy`, providers, case-insensitivity or the Verb-Noun command
  system. A `Verb-Noun` export has no Bash# call name: call it by string
  with `ps.call("Get-Item", path)`.
- **Not the guest runtime:** Windows PowerShell 5.1. The fence always runs
  on the provisioned PowerShell 7.

### C# (`~~~csharp`, alias `~~~cs`)

```csharp
using System;
using System.Linq;

public static long Add(long a, long b) => a + b;
```

- A `~~~csharp` fence is a declaration unit, not a program: leading
  `using` lines, then `public static` methods. Only `public static`
  methods become Bash# callables; instance members and helpers stay inside
  the fence. No top-level statements, no `Main`.
- It compiles through `Add-Type` inside the same provisioned PowerShell 7
  worker — the one archive serves both fences. Compiler errors name the
  script file and the fence's own lines. A NuGet directive (`#:package`,
  `#r "nuget: …"`) is refused with a diagnostic.
- Parameters and results map by the same table as PowerShell (`string`,
  `long`, `double`, `bool`, `byte[]`, objects as JSON). An uncaught
  exception is the call's error carrying the exception type, e.g.
  `InvalidOperationException: demo`.

## 5. Lowered runs need the same runtime

A transpiled Bash# program embeds the fence source and the resolved
environment plan, and interpreted and lowered runs agree byte for byte —
but the lowered binary still needs PowerShell 7 where it runs, just as a
lowered Python fence needs Python. It embeds neither PowerShell nor a
compiled C# assembly.

## 6. What runs the fences, and under which license

Each fence resolves its tool through bashy's toolchain resolver to a
pinned, digest-verified download executed as a separate process — never
from `PATH`. The one escape hatch per tool is a `BASHPP_*` override
(`BASHPP_PWSH` names a PowerShell explicitly); the run's plan records it.

- **PowerShell 7.6.6** (upstream PowerShell/PowerShell, one archive per
  platform: Windows x64/arm64, Linux x64/arm64/musl-x64, macOS x64/arm64).
  Every archive's root `LICENSE.txt` reads MIT, and every archive's root
  `ThirdPartyNotices.txt` matches the repository notice (MIT and
  BSD-2-Clause rows, including the Roslyn 5.0 compiler assemblies under
  MIT). The Windows zips additionally carry closed Microsoft native
  redistributables that the common notice does not rule on. Full
  per-archive evidence with SHA-256 pins: `docs/fence-toolchain-licenses.md`
  in the bashy repo.
- Nothing from Microsoft is compiled into, linked with or vendored in
  bashy: the runtime is download-and-exec beside it, under the same policy
  as every other fence toolchain.

## 7. Where to read next

- [`workflow.bsh`](workflow.bsh) — the one portable workflow, with its
  pinned transcript in `workflow.expected` (what `../check.sh` diffs).
- `04-islands/powershell.bsh` and `04-islands/csharp.bsh` — one file per
  island, beside the Python, TypeScript, Rust, C, C++, Go, bash and sh
  islands.
- The fence reference: `docs/bashpp-polyglot-fences.md` in the language
  engine repo (one section per language), and the full contract with the
  value table, command-form statuses and cache rules in
  `docs/powershell-csharp-fences.md` in the language repo.
