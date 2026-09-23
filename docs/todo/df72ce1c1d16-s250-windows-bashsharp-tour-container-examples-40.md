---
id: df72ce1c1d16
kind: bug
title: S250 Windows BashSharp Tour container examples 40/40
seq: 6
status: done
priority: p1
labels:
    - windows
    - tour
created: 2026-09-23T16:20:25.106168Z
assignee: codex-s250
sprint: 250
sprint_id: c912e608-edfe-59b8-bd36-a98f6dad1634
sprint_title: Validate Go by Example, Go Tour and BashSharp Tour on three hosts
closed: 2026-09-23T17:06:16.438982Z
closed_by: codex-s250
---

On noviwin1 the unchanged Tour gate reports declared XFAIL for advanced/dockerfile and advanced/k8s because the managed Podman engine is unavailable. Establish a running engine or repair the Bashy provisioner/root cause, rerun both exact cases and full 40-case Tour, then remove only the proven stale Windows markers. Keep transcripts and time limits.
