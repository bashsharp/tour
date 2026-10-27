---
id: 729a9dcea673
kind: task
title: 'engine cases on peer CI: drop ci:darwin/ci:windows xfail when tour gate runs on peers with an engine'
seq: 11
status: todo
priority: p2
labels:
    - known-failures
created: 2026-10-27T20:18:04.344241Z
due: 2027-01-31T00:00:00Z
sprint: 517
sprint_id: 4589176f-2dd8-5458-bf93-1a15066eb26c
sprint_title: 'known failures to zero: Windows fleet fences, engine cases on peers, transpile-lowered skip; no xfail without a story and a date'
---

advanced/dockerfile + advanced/k8s PASS on macOS and Windows peers via S514.R6 release-preflight (S517.4 evidence, bashy 4459d522). GitHub-hosted runners have no container engine, so the tour workflow still needs ci: markers until CI runs on peers (S515 act_runner direction). Target: peer CI covers the tour gate, then remove these markers same-delivery.
