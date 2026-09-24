---
id: bf6b6d106993
kind: test
title: Expose downloaded Bashy on Windows Tour runner PATH
seq: 9
status: todo
priority: p2
labels:
    - tour
    - windows
    - ci
created: 2026-09-24T02:27:49.17251Z
sprint: 266
sprint_id: 16738595-c072-5838-be1b-603932c6df8e
sprint_title: Bashy shell, Coreutils, and BashSharp follow-up after v0.28.0
---

v0.28.0-dev six-leg BashSharp Tour workflow 35946620297 at Tour cadae553 had both Windows host and stripped legs at 35 passed, 4 failed, 1 skipped. Two failures are independently diagnosed from raw logs: commands/register and text-fences/registered execute `bashy` inside the fixture and receive `bashy: command not found`, although the top-level runner launches the downloaded D:\a\tour\tour\bashy.exe successfully. Next sprint: put the checksummed downloaded Bashy directory on the fixture child PATH for Windows runner legs, verify command registration in both modes, and rerun unchanged Tour cases with original limits. The other two failures are the Podman machine setup tracked separately by Story f29d27b53aa4. Do not change v0.28.0 tags or bytes.
