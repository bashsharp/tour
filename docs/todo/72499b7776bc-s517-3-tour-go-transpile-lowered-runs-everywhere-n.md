---
id: 72499b7776bc
kind: task
title: S517.3 tour go/transpile-lowered runs everywhere (no SKIP)
seq: 10
status: todo
priority: p1
labels:
    - known-failures
created: 2026-10-27T17:04:27.158378Z
sprint: 517
sprint_id: 4589176f-2dd8-5458-bf93-1a15066eb26c
sprint_title: 'known failures to zero: Windows fleet fences, engine cases on peers, transpile-lowered skip; no xfail without a story and a date'
---

The case SKIPs in every QA lane: 'set BASHSHARP_SH_ROOT to a github.com/qiangli/sh checkout: the lowered program imports its shellrt runtime'. Make it run without manual setup: e.g. resolve the sh source from bashy's pinned module (bashy src / go mod download of the pinned mvdan.cc/sh => qiangli/sh) inside check.sh, or have the QA lane provide it. KISS, reuse existing src/mod commands. No skips or xfail markers added; remove the case's xfail marker in bashsharp-tour cases.tsv in the same delivery once it passes. Native verification on the Windows host required (host-access file ~/.bashy/s514-windows-test-host, outpost ssh key auth). No hostnames in code/docs.
