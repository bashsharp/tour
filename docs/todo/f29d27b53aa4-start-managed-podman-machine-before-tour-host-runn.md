---
id: f29d27b53aa4
kind: test
title: Start managed Podman machine before Tour host runner cases
seq: 8
status: todo
priority: p2
labels:
    - tour
    - podman
    - ci
created: 2026-09-24T02:22:45.805983Z
sprint: 266
sprint_id: 16738595-c072-5838-be1b-603932c6df8e
sprint_title: Bashy shell, Coreutils, and BashSharp follow-up after v0.28.0
---

v0.28.0-dev six-leg BashSharp Tour workflow 35946620297 at Tour cadae553 had macOS host 37 passed, 2 failed, 1 skipped: advanced/dockerfile and advanced/k8s could not connect to the managed Podman socket because the ephemeral runner did not start a Podman machine. The candidate shell and 37 other cases passed; the separate Mac published-byte host lane passed 40/40 with a running machine. Next sprint: prepare the Podman machine in host-mode runner setup using the downloaded Bashy-managed engine, prove readiness before the two advanced cases, and rerun the unchanged six-leg tour on a follow-up head. Keep original fixtures, expected output, and limits; do not change v0.28.0 tags or bytes. Include Windows host leg only if its final failure has the same diagnosed cause.
