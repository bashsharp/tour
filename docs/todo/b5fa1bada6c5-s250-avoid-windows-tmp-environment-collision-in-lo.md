---
id: b5fa1bada6c5
kind: bug
title: S250 avoid Windows tmp environment collision in lowered Tour build
seq: 4
status: assigned
priority: p0
labels:
    - windows
created: 2026-09-23T10:32:27.409928Z
weave: 4
assignee: qiangli
sprint: 250
sprint_id: c912e608-edfe-59b8-bd36-a98f6dad1634
sprint_title: Validate Go by Example, Go Tour and BashSharp Tour on three hosts
---

The current Windows BashSharp Tour still fails go/transpile-lowered after moving its build directory into the checkout. Go reports that exact per-run directory as its system Temp root and ignores go.mod. In Windows, the shell variable `tmp` collides case-insensitively with the inherited TMP environment variable. Use a distinct build_dir variable so the Go child retains the real system Temp path, preserve cleanup and fixtures, then rerun the unchanged full Tour on the current Bashy candidate. Sprint 250 Story #676; supersedes the incomplete result of Story #3.
