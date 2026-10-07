# Fleet definitions as language values

A fleet definition can be inline or read from a file. Both forms expose the
same methods, results, errors and effect checks. All eight examples are registered in `cases.tsv` with recorded stdout/stderr
and exit status. Run only this chapter without provisioning island toolchains:

```sh
TOUR_FILTER=fleet/ ./check.sh /path/to/bashy
```

| Kind | Inline | Embedded | Method |
|---|---|---|---|
| Model | [model-inline.bsh](model-inline.bsh) | [model-embed.bsh](model-embed.bsh) | `run(prompt)` |
| Tool | [tool-inline.bsh](tool-inline.bsh) | [tool-embed.bsh](tool-embed.bsh) | Declared `review(args)` |
| Agent | [agent-inline.bsh](agent-inline.bsh) | [agent-embed.bsh](agent-embed.bsh) | `run(instruction)` |
| Skill | [skill-inline.bsh](skill-inline.bsh) | [skill-embed.bsh](skill-embed.bsh) | `verify()` with an ensured validation result |

Model and tool definitions resolve the existing fleet catalog. A model or tool
must have one eligible registered agent binding; ambiguous bindings are an
error. The examples use `fleet-tour-agent`, bound to `fleet-tour-tool` and
`fleet-tour-model`. The tool declares a `review` command with a `read`
effect. Calls use the existing governed chat/tool runner and spend accounting.

The [reply fixture](fixtures/reply.bsh) is a deterministic local transport:
it prints `recorded answer`, ignores the prompt, and never contacts a model.
The existing runner's `fleet` mode invokes [run.sh](fixtures/run.sh), which
creates a private catalog, config/cache directories, chat/room state and spend
meter for each case, registers tool/model/agent through the catalog CLI verbs,
and removes the state afterward. Shared catalog paths and seeded bindings are
disabled. The launch executes the tested Bashy binary on `reply.bsh`; no model
API is contacted. The model is a local fixture binding, not a provider emulator.
Catalog resolution, launch governance and metering still use the real harness.
The transcripts assert results and exit status. The fixture also requires a
transport marker and positive metered tokens for calls that run, and no
transport marker for admission denials. These are local harness estimates,
not provider-reported usage.

Three additional registered cases record refusal outside an agentic caller,
refusal under a read-only cap, and an `@ensure` mismatch. They use the same
fixture setup and CLI. The eight successful cases check errors before returning
answers. Skill examples validate the prose skill with the existing `verify`
verb; they do not pretend to execute its prose. The separate skill target tour
belongs to the skill-method integration.

Agent definitions also accept an unmodified ycode or genie `agent.yaml`
(`apiVersion: ycode.dev/v1alpha1`, `kind: Harness`). Embed the complete
existing artifact; do not copy just its model and prompt. Compilation retains
imports, routes, retry policy, permissions, budgets, and the sole Bashy tool.
Relative imports and roots resolve beside the definition file, or beside the
script for inline YAML. The script uses the YAML CLI root's one-shot input
route. Unknown fields and multiple YAML documents fail compilation.

A registered agent binding gets an ephemeral fleet clone for the script.
A full YAML harness gets a fresh durable session of its compiled roster,
with the authored agent reference unchanged. Closing the script cancels and
settles its live session; durable event and usage evidence remains. Provider
attempts reserve capacity and settle usage through the existing spend gate.
A spend gate cannot silently select a different YAML route. Missing usage
receipts are marked as estimates; uncertain interrupted requests retain their
reservation for reconciliation.

Model, tool and agent calls in this chapter require an `agentic` caller.
A `read`-only guard denies their `exec,net,spend` effects before transport.
The successful examples judge the answer with `@ensure`. For a denial
exercise, remove `agentic`, or change the guard to `@guard(effects: "read")`.
Skill targets retain the effects declared in their task file.

All four rows run interpreted. Transpilation refuses them by name and points
back to the interpreted route. No interpreter path calls a model directly.

The fixture-backed implementation tests cover both full YAML examples in both
forms, agentic and effect denials, judged output, malformed definitions,
provider usage, hard-spend refusal, and cancellation cleanup. The skill target
examples are supplied by the skill integration.

[Back to the tour](../)
