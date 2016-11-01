url=$1
lastUpdate=$2
refreshSpeed=$3
[[ -z $refreshSpeed ]] && refreshSpeed=5
liveUrl=$(echo $url | sed 's/\(www\.\)theguardian.com/api.nextgen.guardianapps.co.uk/')'.json'
[[ ! -z $lastUpdate ]] && liveUrl=$(echo $liveUrl"?lastUpdate=$lastUpdate&isLivePage=true")

while true; do
  json=$(curl --silent $liveUrl)
  html=$(jq -r '.html' <<<$json)

  if [[ ! -z $html ]]; then
    lastUpdate=$(echo "$html" | egrep '^\s+id="block-' | head -1 | gsed 's/.*id="//; s/"$//')
    liveUrl=$(echo "$liveUrl" | gsed "s/\?.*$//")"?lastUpdate=$lastUpdate&isLivePage=true"

    echo --
    echo "$html" \
    | pandoc -f html -t markdown-raw_html-native_divs-native_spans \
    | tr '\n' '\r' \
    | sed 's/Facebook.*$//' \
    | tr '\r' '\n'
  else
    echo '.\c'
  fi

  sleep $refreshSpeed
done
