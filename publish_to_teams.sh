#!/bin/sh
build_url="[Codemagic Build URL](https://codemagic.io/app/$FCI_PROJECT_ID/$FCI_BUILD_ID)"
jq --arg a "$build_url" '.sections[].facts[.sections[].facts| length] |= . + {"name": "Build", "value": $a}' teams.json > tmp && mv tmp teams.json
ipa=$(jq -r '.[] | select(.type=="ipa") | .url' <<< "$FCI_ARTIFACT_LINKS")
if [ $ipa ]; then
  ipa_url="[Codemagic .ipa URL]($ipa)"
  jq --arg a "$ipa_url" '.sections[].facts[.sections[].facts| length] |= . + {"name": ".ipa", "value": $a}' teams.json > tmp && mv tmp teams.json
else
  echo "no ipas found"
fi
apk=$(jq -r '.[] | select(.type=="apk") | .url' <<< "$FCI_ARTIFACT_LINKS")
if [ $apk ]; then
  apk_url="[Codemagic .apk URL]($apk)"
  jq --arg a "$apk" '.sections[].facts[.sections[].facts| length] |= . + {"name": ".apk", "value": $a}' teams.json > tmp && mv tmp teams.json
else
  echo "no apks found"
fi
aab=$(jq -r '.[] | select(.type=="aab") | .url' <<< "$FCI_ARTIFACT_LINKS")
if [ $aab ]; then
  aab_url="[Codemagic .aab URL]($aab)"
  jq --arg a "$aab_url" '.sections[].facts[.sections[].facts| length] |= . + {"name": ".aab", "value": $a}' teams.json > tmp && mv tmp teams.json
else
  echo "no aabs found"
fi
post=$(cat teams.json)
curl -H 'Content-Type: application/json' -d "$post" $MS_TEAMS_URL
