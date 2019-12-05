# cat 1-1.input | jq -sf 1-1.jq
map(. / 3 | floor - 2) | add
