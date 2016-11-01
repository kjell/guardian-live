# the first page only loads so many events, so this might not
# actually be the first update.
# TODO - find the actual first event
liveUrl=$(echo $1 | sed 's/\(www\.\)theguardian.com/api.nextgen.guardianapps.co.uk/')'.json'
curl --silent "$liveUrl" \
| jq -r '.html' \
| egrep '^\s+id="block-' \
| tail -1 \
| gsed 's/.*id="//; s/"$//'
