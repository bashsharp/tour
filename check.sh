#!/bin/sh
# The Bash# tour gate (e2e). Runs every case in cases.tsv on a bashy binary —
# by default the one on PATH, i.e. the INSTALLED binary — and diffs
# stdout+stderr AND the exit status against the pinned transcript
# (FILE.expected, first line "# rc=N").
#
#   ./check.sh                       # the bashy on PATH
#   ./check.sh /path/to/bashy        # another binary
#   BASHSHARP_FLAG=--bashpp ./check.sh        # a binary older than the rename
#   BASHSHARP_SH_ROOT=/path/to/sh ./check.sh  # also build the lowered Go (needs go >= 1.27)
#   ./check.sh --pin                 # re-pin every transcript from this binary (maintainers)
#
# No toolchain is needed on the host: bashy provisions what an island uses
# (a pinned Go, zig cc, a uv-managed CPython, Node + the typescript package,
# a rustup toolchain — downloaded and checksum-verified on first use, then
# cached). A fence never resolves its tool from PATH, so a host tool that is
# present is invisible and one that is absent is not a reason to skip: the
# gate runs every case, and the same binary must produce the same transcript
# with the toolchains on PATH and with them stripped (the CI's two legs).
# Nothing is SKIPPED for a missing tool; the `needs` column in cases.tsv
# records what bashy provisions for the case.
set -u
here=$(cd "$(dirname "$0")" && pwd)
export BASHY_HINTS=off
pin=0; bashy=bashy
for a in "$@"; do case "$a" in --pin) pin=1 ;; *) bashy=$a ;; esac; done
case "$bashy" in
/*|[A-Za-z]:*) ;;                                                        # already absolute (unix, or a Windows drive path)
*/*) bashy=$(cd "$(dirname "$bashy")" && pwd)/$(basename "$bashy") ;;   # relative: cases run from their own directory
esac
# `bashy` inside a case means the binary under test, wherever it sits (a
# Windows path spells its directories with backslashes).
# On Windows bashy keeps PATH in the native ';'-separated spelling, and a
# list with a ';' is split on ';' only — a ':' prepend would glue this
# directory onto the first entry and lose both, so join with the list's own
# separator.
case "$bashy" in */*|*\\*)
    bdir=$(dirname "$bashy"); [ "$bdir" = . ] && case "$bashy" in *\\*) bdir=${bashy%\\*} ;; esac
    case "$PATH" in *\;*) PATH="$bdir;$PATH" ;; *) PATH="$bdir:$PATH" ;; esac; export PATH ;;
esac
flag=${BASHSHARP_FLAG:-}
if [ -z "$flag" ]; then
    # A binary from before the rename knows the old spelling only.
    if "$bashy" --bashsharp -c : >/dev/null 2>&1; then flag=--bashsharp
    elif "$bashy" --bashpp -c : >/dev/null 2>&1; then flag=--bashpp; echo "tour: note: this bashy predates the rename; using --bashpp for --bashsharp"
    else flag=--bashsharp; fi
fi
noflag=--no-${flag#--}
pass=0; fail=0; skip=0; xfail=0; rc=0
# Provision the islands' toolchains BEFORE the cases (`bashy check --prepare`):
# a first-use download prints its notes, and a transcript must not depend on
# whether this machine has run an island before. Optional for a person; the
# gate does it so its diffs are only ever about the program.
if "$bashy" check --help 2>/dev/null | grep -q -- --prepare; then
    echo "tour: provisioning the island toolchains (bashy check --prepare; cached after the first run)"
    # Relative paths from the tour root: a Windows bashy spells $here in
    # MSYS form, which the OS cannot open and a glob does not expand.
    (cd "$here" && "$bashy" check --prepare 04-islands/python.bsh 04-islands/typescript.bsh 04-islands/rust.bsh 04-islands/c.bsh 04-islands/cpp.bsh 04-islands/go/go.bsh 03-go/03-whole-program.go 09-fences-advanced/builder.bsh 09-fences-advanced/manifests/pyproject/build.bsh 09-fences-advanced/manifests/gomod/build.bsh 09-fences-advanced/manifests/package/build.bsh) || { echo "tour: FAIL check --prepare" >&2; exit 1; }
fi
osname=$(uname -s 2>/dev/null | tr 'A-Z' 'a-z'); case "$osname" in linux|darwin) ;; *) osname=windows ;; esac

# The island toolchains come from bashy, never from this host: a BASHPP_*
# override inherited from the environment would make the transcript depend on
# the host, so the gate runs without them.
unset BASHPP_PYTHON BASHPP_GO BASHPP_CC BASHPP_CXX BASHPP_RUSTC BASHPP_NODE BASHPP_BUN BASHPP_TYPESCRIPT_RUNTIME BASHPP_TYPESCRIPT_MODULE
# A CI runner's log annotations are the runner's, not the program's: `bashy dag`
# groups its target output under GITHUB_ACTIONS, and a ~~~dag fence would carry
# the markers into its value. The cases run as on a stranger's machine.
# Remembered first: a `ci:OS=card` xfail marker (cases.tsv) applies on CI only.
on_ci=${GITHUB_ACTIONS:-}
unset GITHUB_ACTIONS CI
# The container-engine cases (needs podman) reach bashy's own podman when the
# host has none on PATH; its first-run fetch note must not land in a transcript
# either, so warm it on Linux the way `check --prepare` warms the islands. On
# macOS/Windows without a machine the cases are known-failing (see cases.tsv).
case "$osname" in linux) "$bashy" podman version >/dev/null 2>&1 || true ;; esac
invoke() { # mode file -> runs in the file's directory, prints stdout+stderr, returns status
    dir=$(dirname "$here/$2"); base=$(basename "$2")
    case "$1" in
    run)   (cd "$dir" && "$bashy" "$flag" "$base" 2>&1) ;;
    off)   (cd "$dir" && "$bashy" "$noflag" "$base" 2>&1) ;;
    posix) (cd "$dir" && "$bashy" --posix "$base" 2>&1) ;;
    gosrc) (cd "$dir" && "$bashy" "$flag" --source=go "$base" 2>&1) ;;
    check) (cd "$dir" && "$bashy" check "$flag" "$base" 2>&1) ;;
    esac
}
report() { # id expected-file actual-text actual-rc expected-rc xfail-spec
    want=$(sed 1d "$2")
    xf=""; for spec in $(printf '%s' "${6:-}" | tr ';' ' '); do case "$spec" in "$osname="*) xf=${spec#*=} ;; "ci:$osname="*) [ -n "$on_ci" ] && xf=${spec#*=} ;; esac; done
    if [ "$3" = "$want" ] && [ "$4" -eq "$5" ]; then
        if [ -n "$xf" ]; then
            echo "tour: XPASS $1 — marked xfail on $osname ($xf) but PASSED: remove the marker" >&2
            fail=$((fail+1)); rc=1
        else
            echo "tour: PASS $1"; pass=$((pass+1))
        fi
    elif [ -n "$xf" ]; then
        echo "tour: XFAIL $1 (known on $osname: $xf; exit $4)"; xfail=$((xfail+1))
    else
        echo "tour: FAIL $1 (exit $4, expected $5; $bashy $flag)" >&2
        printf '%s\n' "$3" | diff -u "$2" - >&2 || true
        fail=$((fail+1)); rc=1
    fi
}

while IFS="$(printf '\t')" read -r id mode file needs want_rc xfail_spec; do
    case "$id" in ''|'#'*) continue ;; esac
    exp="$here/${file%.*}.expected"
    [ "$mode" = off ] && exp="$here/${file%.*}.off.expected"
    out=$(invoke "$mode" "$file"); got=$?
    if [ "$pin" -eq 1 ]; then
        { printf '# rc=%s\n' "$got"; printf '%s\n' "$out"; } > "$exp"; echo "tour: PINNED $id (rc=$got)"; continue
    fi
    report "$id" "$exp" "$out" "$got" "$want_rc" "${xfail_spec:-}"
done < "$here/cases.tsv"

# The lowered build of 03-go/04-transpile.bsh: builds the emitted Go with
# bashy's own provisioned Go (`bashy go`, >= 1.27) and needs a checkout of
# github.com/qiangli/sh (the emitted Go imports its shellrt runtime).
if [ "$pin" -eq 0 ]; then
    if [ -z "${BASHSHARP_SH_ROOT:-}" ] || [ ! -d "$BASHSHARP_SH_ROOT/lower/shellrt" ]; then
        echo "tour: SKIP go/transpile-lowered (set BASHSHARP_SH_ROOT to a github.com/qiangli/sh checkout: the lowered program imports its shellrt runtime)"; skip=$((skip+1))
    else
        # Go 1.27 ignores a go.mod below the Windows system Temp root.  Keep
        # this per-run module in the writable Tour checkout instead.
        build_dir=$(mktemp -d "$here/.tour-go-build.XXXXXX"); trap 'rm -rf "$build_dir"' EXIT
        printf 'module tour\n\ngo 1.27\n\nrequire mvdan.cc/sh/v3 v3.0.0\nreplace mvdan.cc/sh/v3 => %s\n' "$BASHSHARP_SH_ROOT" >"$build_dir/go.mod"
        if (cd "$build_dir" && GOFLAGS=-mod=mod "$bashy" transpile "$flag" "$here/03-go/04-transpile.bsh" -o "$build_dir/t.go" >"$build_dir/log" 2>&1 \
             && GOWORK=off GOFLAGS=-mod=mod "$bashy" go build -o program t.go >>"$build_dir/log" 2>&1) \
           && out=$("$build_dir/program" 2>&1) && [ "$out" = "$(sed 1d "$here/03-go/04-transpile.expected")" ]; then
            echo "tour: PASS go/transpile-lowered (built as Go, same transcript)"; pass=$((pass+1))
        else
            echo "tour: FAIL go/transpile-lowered" >&2; cat "$build_dir/log" >&2; printf '%s\n' "${out-}" >&2; fail=$((fail+1)); rc=1
        fi
    fi
fi

[ "$pin" -eq 1 ] && exit 0
echo "tour: $pass passed, $fail failed, $skip skipped, $xfail known-failing ($("$bashy" --version 2>/dev/null | head -1))"
exit $rc
