#!/usr/bin/env bash
set -euo pipefail

PATH="$PATH:/opt/homebrew/bin"

task export | jq -r 'map(select(.status == "pending" and .rtype == null and .depends == null)) | sort_by(.urgency) | reverse | "\(.[0].id): \(if .[0].description | length > 30 then .[0].description | .[0:30] + "…" else .[0].description end)\n---\n\(.[0:30] | map("\(.id): \(.description)\n-- Mark Done | shell=task | param1=\(.uuid) | param2=done | refresh=true\n--project: \(.project)\n-- priority: \(.priority)\n-- uregency: \(.urgency)") | join("\n"))"'
