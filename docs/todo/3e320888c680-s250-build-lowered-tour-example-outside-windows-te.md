---
id: 3e320888c680
kind: bug
title: S250 build lowered Tour example outside Windows temp root
seq: 3
status: done
priority: p0
labels:
    - windows
created: 2026-09-23T10:12:45.265248Z
weave: 3
assignee: qiangli
sprint: 250
sprint_id: c912e608-edfe-59b8-bd36-a98f6dad1634
sprint_title: Validate Go by Example, Go Tour and BashSharp Tour on three hosts
closed: 2026-09-23T10:18:40.281091Z
closed_by: codex-s250
---

On Windows, the BashSharp Tour go/transpile-lowered case now transpiles its /c/... source, but Go 1.27.1 ignores go.mod in the mktemp directory under the Windows system Temp root, then cannot resolve mvdan.cc/sh/v3/lower/shellrt. Use a writable per-run build directory outside the system Temp root, preserve cleanup, source, transcript and unchanged time limits, and rerun this case and full Tour. Sprint 250 Story #676.
