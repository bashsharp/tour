# Recordings

Terminal recordings used by the README and the announcement posts. Each
`.cast` is an [asciinema](https://asciinema.org) v3 file; the `.gif` next to
it is rendered with [`agg`](https://github.com/asciinema/agg).

| Recording | What it shows | How it was made |
| --- | --- | --- |
| `judge.cast` / `judge.gif` | the quickstart: one `agentic` function under three contracts, six calls, six exit codes, on the released `bashy` | `record-judge.sh` under `asciinema rec` with `TOUR=<this repo>` and the release binary first on `PATH` |
| `windows-rebuild.cast` / `windows-rebuild.gif` | a stock Windows box (no git, no Go, no C compiler): download the zip, `bashy git clone`, `bashy scripts/bootstrap-siblings.sh`, `bashy dag build`, run the result | `record-windows-rebuild.ps1` run in PowerShell over an ssh pty under `asciinema rec` |

Re-render a gif:

```sh
agg --cols 100 --rows 32 --font-size 16 casts/judge.cast casts/judge.gif
agg --cols 80 --rows 24 --font-size 16 casts/windows-rebuild.cast casts/windows-rebuild.gif
```

The recordings are made with `BASHY_HINTS=off` and `BASHY_TELEMETRY_QUIET=1`
so the frames show only what the commands print.
