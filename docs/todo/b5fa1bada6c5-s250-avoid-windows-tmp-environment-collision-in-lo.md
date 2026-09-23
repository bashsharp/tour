---
id: b5fa1bada6c5
kind: bug
title: S250 avoid Windows tmp environment collision in lowered Tour build
seq: 4
status: done
priority: p0
labels:
    - windows
created: 2026-09-23T10:32:27.409928Z
weave: 4
assignee: qiangli
sprint: 250
sprint_id: c912e608-edfe-59b8-bd36-a98f6dad1634
sprint_title: Validate Go by Example, Go Tour and BashSharp Tour on three hosts
closed: 2026-09-23T10:36:50.081975Z
closed_by: codex-s250
---

The current Windows BashSharp Tour still fails go/transpile-lowered after moving its build directory into the checkout. Go reports that exact per-run directory as its system Temp root and ignores go.mod. In Windows, the shell variable `tmp` collides case-insensitively with the inherited TMP environment variable. Use a distinct build_dir variable so the Go child retains the real system Temp path, preserve cleanup and fixtures, then rerun the unchanged full Tour on the current Bashy candidate. Sprint 250 Story #676; supersedes the incomplete result of Story #3.

Delivery: `bashsharp-tour@7008e72` uses `build_dir`. A clean Windows checkout at that revision passed the unchanged full Tour with the current Bashy candidate: 36 pass, 0 fail, 0 skip, 4 previously declared Windows XFAIL. The lowered Go build passed against the pinned transcript. Candidate binary SHA-256 `8654a2e2025ab2a1471c1a1eea6020a5fe5634c7ec987a036dbe4322594f7406`; full Tour log SHA-256 `511ae95143dcf0fcc63d4dfa0dfcf80fdef21153e3e20c9e440d86ba01b0240`.
