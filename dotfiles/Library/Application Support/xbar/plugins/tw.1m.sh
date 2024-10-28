#!/usr/bin/env bash
set -euo pipefail

PATH="$PATH:/opt/homebrew/bin"

NOW="$(date -u "+%Y%m%dT%H%M%SZ")"

task export | jq --arg NOW "$NOW" -r 'map(select(.status == "pending" and .depends == null and (.wait == null or .wait <= $NOW))) | sort_by(.urgency) | reverse | "\(.[0].id): \(if .[0].description | length > 30 then .[0].description | .[0:30] + "…" else .[0].description end)\n---\n\(.[0:20] | map("\(.id): \(.description)\n-- Mark Done | shell=/opt/homebrew/bin/task | param1=\(.uuid) | param2=done | refresh=true\n--project: \(.project)\n-- priority: \(.priority)\n-- urgency: \(.urgency)\(if .recur then "\n-- recur: \(.recur)" else "" end)\n-- wait: \(.wait)\n-- due: \(.due)") | join("\n"))"'
