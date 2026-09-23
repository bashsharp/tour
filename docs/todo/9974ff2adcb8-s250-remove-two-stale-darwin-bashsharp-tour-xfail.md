---
id: 9974ff2adcb8
kind: bug
title: S250 remove two stale Darwin BashSharp Tour xfail markers
seq: 5
status: assigned
priority: p0
created: 2026-09-23T11:28:30.075156Z
weave: 5
assignee: qiangli
sprint: 250
sprint_id: c912e608-edfe-59b8-bd36-a98f6dad1634
sprint_title: Validate Go by Example, Go Tour and BashSharp Tour on three hosts
---

On authenticated macOS candidate bashy@5353ba3 and sh@3d5559e, unchanged BashSharp Tour with BASHSHARP_SH_ROOT executes all 40 cases: 38 PASS, 2 XPASS-as-fail, 0 SKIP. The two outputs match pinned transcripts exactly: advanced/dockerfile and advanced/k8s. In cases.tsv remove only their darwin=todo:9e360c57 markers; keep windows markers, scripts, transcripts, and limits untouched. Verify full 40/40 with exact candidate; Story #89 of Sprint 250 owns integration evidence.
