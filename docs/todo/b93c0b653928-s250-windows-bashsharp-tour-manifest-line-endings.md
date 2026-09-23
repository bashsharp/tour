---
id: b93c0b653928
kind: bug
title: S250 Windows BashSharp Tour manifest line endings
seq: 7
status: done
priority: p1
labels:
    - windows
    - tour
created: 2026-09-23T16:20:25.106627Z
assignee: codex-s250
sprint: 250
sprint_id: c912e608-edfe-59b8-bd36-a98f6dad1634
sprint_title: Validate Go by Example, Go Tour and BashSharp Tour on three hosts
closed: 2026-09-23T17:06:57.546996Z
closed_by: codex-s250
---

On noviwin1 the unchanged Tour gate reports declared XFAIL for manifests/pyproject and manifests/package due Windows CR handling. Diagnose program versus Bashy root cause; repair narrowly, rerun exact cases and full 40-case Tour, then remove only proven stale Windows markers. Keep original transcripts and time limits.
