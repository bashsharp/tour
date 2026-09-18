#!/bin/bash
# The judge demo on the released bashy. Shows the commands as if typed, then runs them.
cd "$TOUR"
say() { printf '\033[1;32m$\033[0m %s\n' "$*"; sleep "${PAUSE:-1.2}"; }
say "bashy --version"
bashy --version; sleep 1.5
say "sed -n '19,32p' 00-quickstart/judge.bsh      # one agentic function under three contracts"
sed -n '19,32p' 00-quickstart/judge.bsh; sleep 4
say "bashy --bashsharp 00-quickstart/judge.bsh    # six calls, six exit codes"
bashy --bashsharp 00-quickstart/judge.bsh 2>&1 | sed -n '1,13p'; sleep 5
say "# 0 ok · 3 require failed · 3 ensure disagreed · 1 write denied · 1 fail · 6 = YIELD: 'I need input'"
sleep 2
say "# the interpreter never called a model. that is the point."
sleep 3
