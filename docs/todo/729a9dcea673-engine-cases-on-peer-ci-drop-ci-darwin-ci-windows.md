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
sprint: 521
sprint_id: 8215f52e-1496-5a0f-b6f6-729bf3056119
sprint_title: 'Fleet upgrade fix release + ivy deploy: ship outpost upgrade-ordering fix (cd8b98c4) as bashy rc.22, move every host incl. ivy (lern, lj2ivy) onto it once, then promotions auto-flow'
---

advanced/dockerfile + advanced/k8s PASS on macOS and Windows peers via S514.R6 release-preflight (S517.4 evidence, bashy 4459d522). GitHub-hosted runners have no container engine, so the tour workflow still needs ci: markers until CI runs on peers (S515 act_runner direction). Target: peer CI covers the tour gate, then remove these markers same-delivery.
