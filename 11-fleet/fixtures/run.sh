#!/bin/sh
# Called by check.sh's fleet mode; one private catalog and meter per case.
set -eu
testee=$1; flag=$2; script=$3
case "$testee" in /*|[A-Za-z]:*) ;; *) testee=$(command -v "$testee") ;; esac
fixture_state=$(mktemp -d "${TMPDIR:-/tmp}/fleet-tour.XXXXXX")
trap 'rm -rf "$fixture_state"' EXIT HUP INT TERM
unset BASHY_TOOLS_PATH BASHY_MODELS_PATH BASHY_AGENTS_PATH BASHY_SKILLS_PATH
unset BASHY_TOOLS_DIR BASHY_MODELS_DIR BASHY_AGENTS_DIR BASHY_SKILLS_DIR
unset BASHY_LLM_BUDGET_POLICY BASHY_AGENTIC BASHY_AGENT_BINDING BASHY_AGENT_MANIFEST
unset BASHY_ALLOW_PREMIUM LLM_ALLOW_PREMIUM BASHY_ALLOW_UNSAFE_AGENT_LAUNCH
unset BASHY_LLM_BUDGET_DAILY_USD BASHY_LLM_PROVIDER_OPENAI_COMPAT_DAILY_USD
unset BASHY_FLEET_TOKEN BASHY_API_KEY CLOUDBOX_TOKEN BASHY_ACP
unset BASHY_OUTPUT_PARENT BASHY_PRINCIPAL BASHY_AGENT_ID
export BASHY_FORCE_AGENT_SHELL=1
export BASHY_HOME="$fixture_state" BASHY_FLEET_DIR="$fixture_state/fleet"
export XDG_CONFIG_HOME="$fixture_state/config" XDG_CACHE_HOME="$fixture_state/cache"
export BASHY_FLEET_SEEDS=off BASHY_KNOWLEDGE=off BASHY_OUTPUT_REDUCE=off
export BASHY_ROOM_DIR="$fixture_state/rooms" BASHY_CHAT_DIR="$fixture_state/chat"
export FLEET_TOUR_CALL_LOG="$fixture_state/transport.calls"
export BASHY_LLM_BUDGET_STATE="$fixture_state/meter.json"
export BASHY_SHIM_DIR="$fixture_state/shims" BASHY_NO_COACH=1 BASHY_CHAT_INBOX=off
export BASHY_HINTS=off BASHY_AUDIT=0 LC_ALL=C
# Import through catalog verbs, never by writing catalog files directly.
"$testee" tool add fleet-tour-tool \
  --set kind=cli --set "cli.binary=$testee" \
  --set "cli.launch.exec=fleet-tour-tool --bashsharp fixtures/reply.bsh --model {model} {prompt}" \
  --set 'commands=[{"name":"review","slash":"review {args}","mode":"print","effects":["read"]}]' >/dev/null
"$testee" model add fleet-tour-model --provider openai-compat --kind local \
  --upstream fixture --cost-micro 1000 >/dev/null
"$testee" agent add fleet-tour-agent --tool fleet-tour-tool --model fleet-tour-model >/dev/null
status=0
"$testee" "$flag" "$script" || status=$?
case "$script" in
  agent-denied.bsh|model-read-denied.bsh)
    if [ -e "$FLEET_TOUR_CALL_LOG" ]; then
      echo 'fixture: denied call reached transport' >&2; exit 99
    fi ;;
  model-*.bsh|tool-*.bsh|agent-*.bsh)
    if [ ! -s "$FLEET_TOUR_CALL_LOG" ] ||
       ! grep -Eq '"day_tokens": *[1-9][0-9]*' "$BASHY_LLM_BUDGET_STATE"; then
      echo 'fixture: missing transport or metering evidence' >&2; exit 99
    fi ;;
esac
exit "$status"
