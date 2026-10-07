# Fleet definitions as language values

A fleet definition can be inline or read from a file. Both forms expose the
same methods, results, errors and effect checks. These examples target the
fleet-row implementation; the main tour gate will add them with the skill
target-method integration.

| Kind | Inline | Embedded | Method |
|---|---|---|---|
| Model | [model-inline.bsh](model-inline.bsh) | [model-embed.bsh](model-embed.bsh) | `run(prompt)` |
| Tool | [tool-inline.bsh](tool-inline.bsh) | [tool-embed.bsh](tool-embed.bsh) | Declared `review(args)` |
| Agent | [agent-inline.bsh](agent-inline.bsh) | [agent-embed.bsh](agent-embed.bsh) | `run(instruction)` |
| Skill | [skill-inline.bsh](skill-inline.bsh) | [skill-embed.bsh](skill-embed.bsh) | `verify()`; declared task targets after integration |

Model and tool definitions resolve the existing fleet catalog. A model or tool
must have one eligible registered agent binding; ambiguous bindings are an
error. The examples use `fleet-tour-agent`, bound to `fleet-tour-tool` and
`fleet-tour-model`. The tool declares a `review` command with a `read`
effect. Calls use the existing governed chat/tool runner and spend accounting.

The [reply fixture](fixtures/reply.bsh) is a deterministic local transport:
it prints `recorded answer`, ignores the prompt, and never contacts a model.
Use it as the tool's launch command when preparing this chapter's isolated
fixture catalog. Do not point the fixture bindings at a paid model. The exact
catalog setup and eight transcripts must be verified against the integrated
binary before these cases enter `cases.tsv`.

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
exercise, remove `agentic`, or change the guard to `@guard("read")`.
Skill targets retain the effects declared in their task file.

All four rows run interpreted. Transpilation refuses them by name and points
back to the interpreted route. No interpreter path calls a model directly.

The fixture-backed implementation tests cover both full YAML examples in both
forms, agentic and effect denials, judged output, malformed definitions,
provider usage, hard-spend refusal, and cancellation cleanup. The skill target
examples are supplied by the skill integration.

[Back to the tour](../)
