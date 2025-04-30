#!/bin/bash

SELECTED=$(gob-curl -s 'https://gso-fact-internal-review.git.corp.google.com/changes/?q=owner:gabrielford@google.com+is:open' \
  | tail -n +2 \
	| jq -r '.[] | "\(.subject) -- \(._number) -- \(.current_revision_number)"' \
  | fzf)

IFS=$'\n'

declare -a 'SPLIT=($(sed "s/ -- /\n/g" <<< $SELECTED))'

CL_NUMBER=${SPLIT[1]}
CL_LATEST_REVISION=${SPLIT[2]}

echo "Pulling CL $CL_NUMBER at revision $CL_LATEST_REVISION."

CL_REMOTE_REF=refs/changes/${CL_NUMBER:(-2)}/${CL_NUMBER}/${CL_LATEST_REVISION}

echo $CL_REMOTE_REF
