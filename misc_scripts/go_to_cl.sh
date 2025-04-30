#!/bin/bash

gob-curl -s 'https://gso-fact-internal-review.git.corp.google.com/changes/?q=owner:gabrielford@google.com+is:open' | tail -n +2 | jq -r '.[] | "\(.subject) -- \(._number) -- \(.current_revision_number)"' | fzf | lolcat
