---
id: 4562f66dd233
kind: bug
title: S250 remove three stale Windows Tour xfail markers
seq: 1
status: todo
priority: p1
created: 2026-09-23T09:43:52.745864Z
sprint: 250
sprint_id: c912e608-edfe-59b8-bd36-a98f6dad1634
sprint_title: Validate Go by Example, Go Tour and BashSharp Tour on three hosts
---

Windows noviwin1 published Bashy 0.27.0 makes commands/register, text-fences/registered and manifests/gomod pass their pinned transcripts, but cases.tsv still marks them windows=todo and check.sh reports XPASS. Remove only these three markers after confirming on the current candidate. Run the complete BashSharp Tour on Windows and record exact result. Evidence: dhnt docs/sprint-250-story-676-noviwin1-evidence.md. Sprint 250 Story #676.
