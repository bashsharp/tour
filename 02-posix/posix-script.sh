#!/bin/sh
# Standard — POSIX.1-2016. Under `bashy --posix` the shell is a POSIX shell
# through the same engine, and the utilities it calls are the pure-Go
# coreutils: one identical toolset on Linux, macOS and Windows.

n=0
for w in alpha beta gamma; do
    n=$((n+1))
    printf '%d %s\n' "$n" "$w"
done
printf '%s\n' "$(echo hello | tr a-z A-Z)"
