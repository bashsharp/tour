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
# A case whose runtime is missing is SKIPPED by name with the reason. A SKIP
# never counts as a pass; the summary line reports all three numbers.
set -u
here=$(cd "$(dirname "$0")" && pwd)
export BASHY_HINTS=off
pin=0; bashy=bashy
for a in "$@"; do case "$a" in --pin) pin=1 ;; *) bashy=$a ;; esac; done
case "$bashy" in
/*|[A-Za-z]:*) ;;                                                        # already absolute (unix, or a Windows drive path)
*/*) bashy=$(cd "$(dirname "$bashy")" && pwd)/$(basename "$bashy") ;;   # relative: cases run from their own directory
esac
flag=${BASHSHARP_FLAG:-}
if [ -z "$flag" ]; then
    # A binary from before the rename knows the old spelling only.
    if "$bashy" --bashsharp -c : >/dev/null 2>&1; then flag=--bashsharp
    elif "$bashy" --bashpp -c : >/dev/null 2>&1; then flag=--bashpp; echo "tour: note: this bashy predates the rename; using --bashpp for --bashsharp"
    else flag=--bashsharp; fi
fi
noflag=--no-${flag#--}
pass=0; fail=0; skip=0; rc=0

have() { command -v "$1" >/dev/null 2>&1; }
need_ok() { # prints the reason when the need is NOT met
    case "$1" in
    -) ;;
    python3) have python3 || echo "no python3 on PATH" ;;
    cargo) have cargo || echo "no cargo on PATH (install Rust)" ;;
    cc) have cc || echo "no C compiler (cc) on PATH" ;;
    c++) have c++ || echo "no C++ compiler (c++) on PATH" ;;
    go) have go || echo "no go on PATH (the Go island and --source=go need a Go SDK; bashy provisions one for builds, not yet for these)" ;;
    typescript)
        have node || { echo "no node on PATH"; return; }
        m=${BASHPP_TYPESCRIPT_MODULE:-}
        [ -n "$m" ] || { g=$(npm root -g 2>/dev/null); [ -n "$g" ] && [ -d "$g/typescript" ] && m=$g/typescript; }
        [ -n "$m" ] && [ -f "$m/package.json" ] && [ -d "$m/lib" ] || echo "no typescript package (npm install -g typescript, or set BASHPP_TYPESCRIPT_MODULE)"
        [ -n "$m" ] && export BASHPP_TYPESCRIPT_MODULE="$m" ;;
    esac
}
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
report() { # id expected-file actual-text actual-rc expected-rc
    want=$(sed 1d "$2")
    if [ "$3" = "$want" ] && [ "$4" -eq "$5" ]; then
        echo "tour: PASS $1"; pass=$((pass+1))
    else
        echo "tour: FAIL $1 (exit $4, expected $5; $bashy $flag)" >&2
        printf '%s\n' "$3" | diff -u "$2" - >&2 || true
        fail=$((fail+1)); rc=1
    fi
}

while IFS="$(printf '\t')" read -r id mode file needs want_rc; do
    case "$id" in ''|'#'*) continue ;; esac
    exp="$here/${file%.*}.expected"
    [ "$mode" = off ] && exp="$here/${file%.*}.off.expected"
    reason=$(need_ok "$needs")
    if [ -n "$reason" ]; then echo "tour: SKIP $id ($reason)"; skip=$((skip+1)); continue; fi
    out=$(invoke "$mode" "$file"); got=$?
    if [ "$pin" -eq 1 ]; then
        { printf '# rc=%s\n' "$got"; printf '%s\n' "$out"; } > "$exp"; echo "tour: PINNED $id (rc=$got)"; continue
    fi
    report "$id" "$exp" "$out" "$got" "$want_rc"
done < "$here/cases.tsv"

# The lowered build of 03-go/04-transpile.bsh: needs go >= 1.27 on PATH and a
# checkout of github.com/qiangli/sh (the emitted Go imports its shellrt runtime).
if [ "$pin" -eq 0 ]; then
    gover=$(GOTOOLCHAIN=local go version 2>/dev/null | sed -n 's/^go version go\([0-9]*\.[0-9]*\).*/\1/p')
    if [ -z "$gover" ] || [ "$(printf '%s\n1.27\n' "$gover" | sort -V | head -1)" != 1.27 ]; then
        echo "tour: SKIP go/transpile-lowered (needs go >= 1.27 on PATH; found '${gover:-none}')"; skip=$((skip+1))
    elif [ -z "${BASHSHARP_SH_ROOT:-}" ] || [ ! -d "$BASHSHARP_SH_ROOT/lower/shellrt" ]; then
        echo "tour: SKIP go/transpile-lowered (set BASHSHARP_SH_ROOT to a github.com/qiangli/sh checkout: the lowered program imports its shellrt runtime)"; skip=$((skip+1))
    else
        tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
        printf 'module tour\n\ngo 1.27\n\nrequire mvdan.cc/sh/v3 v3.0.0\nreplace mvdan.cc/sh/v3 => %s\n' "$BASHSHARP_SH_ROOT" >"$tmp/go.mod"
        if (cd "$tmp" && GOFLAGS=-mod=mod "$bashy" transpile "$flag" "$here/03-go/04-transpile.bsh" -o "$tmp/t.go" >"$tmp/log" 2>&1 \
             && GOWORK=off GOFLAGS=-mod=mod go build -o program t.go >>"$tmp/log" 2>&1) \
           && out=$("$tmp/program" 2>&1) && [ "$out" = "$(sed 1d "$here/03-go/04-transpile.expected")" ]; then
            echo "tour: PASS go/transpile-lowered (built as Go, same transcript)"; pass=$((pass+1))
        else
            echo "tour: FAIL go/transpile-lowered" >&2; cat "$tmp/log" >&2; printf '%s\n' "${out-}" >&2; fail=$((fail+1)); rc=1
        fi
    fi
fi

[ "$pin" -eq 1 ] && exit 0
echo "tour: $pass passed, $fail failed, $skip skipped ($("$bashy" --version 2>/dev/null | head -1))"
exit $rc
