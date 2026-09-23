---
id: 425edf4699bb
kind: bug
title: S250 remove stale Windows makefile xfail marker
seq: 2
status: done
priority: p1
labels:
    - windows
created: 2026-09-23T10:10:53.79431Z
weave: 2
assignee: qiangli
sprint: 250
sprint_id: c912e608-edfe-59b8-bd36-a98f6dad1634
sprint_title: Validate Go by Example, Go Tour and BashSharp Tour on three hosts
closed: 2026-09-23T10:18:40.165745Z
closed_by: codex-s250
---

Windows BashSharp Tour on a current candidate reports XPASS for manifests/makefile: the case matches its pinned transcript and exits as expected, but cases.tsv still declares windows=todo:041dd280. Remove only that stale marker, preserve fixture and deadline, and rerun the case plus full Tour. Sprint 250 Story #676.
