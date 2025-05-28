#!/bin/bash
BASE_URL="https://gso-fact-internal-review.git.corp.google.com/changes/"

OWNER="owner:$USER@google.com+"
if [[ "$1" == "all_users" ]]; then
  OWNER=""
fi

SELECTED=$(gob-curl -s "${BASE_URL}?q=${OWNER}is:open" \
  | tail -n +2 \
  | jq -r '.[] | "\(.project) -- \(.subject) -- \(._number) -- \(.current_revision_number)"' \
  | fzf)

if [[ -z "$SELECTED" ]]; then
  echo "No CL selected."
  exit 1
fi

IFS=$'\n'

declare -a 'SPLIT=($(sed "s/ -- /\n/g" <<< $SELECTED))'

REPO_NAME=${SPLIT[0]}
CL_NUMBER=${SPLIT[2]}
CL_LATEST_REVISION=${SPLIT[3]}

echo "Fetching $REPO_NAME CL $CL_NUMBER at revision $CL_LATEST_REVISION."

CL_REMOTE_REF=refs/changes/${CL_NUMBER:(-2)}/${CL_NUMBER}/${CL_LATEST_REVISION}

git fetch origin $CL_REMOTE_REF
