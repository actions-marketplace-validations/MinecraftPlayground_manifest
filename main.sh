#!/bin/sh

# Global inputs:
# 
# $INPUT_VERSION
# $INPUT_MANIFEST_URL
# $INPUT_RESOURCES_URL

# Global outputs:
#
# raw-json
# latest-release-version
# latest-snapshot-version
# versions
# release-versions
# snapshot-versions
# april-fools-versions
# type
# url
# time
# release-time

manifest_response=$(curl -L $INPUT_MANIFEST_URL)

raw_json="$manifest_response"
latest_release_version=$(echo "$manifest_response" | jq -r '.latest.release')
latest_snapshot_version=$(echo "$manifest_response" | jq -r '.latest.snapshot')
versions=$(echo "$manifest_response" | jq -c '[.versions[].id] | reverse')
release_versions=$(echo "$manifest_response" | jq -c '[.versions[] | select(.type=="release") | .id] | reverse')
snapshot_versions=$(echo "$manifest_response" | jq -c '[.versions[] | select(.type=="snapshot") | .id] | reverse')
april_fools_versions=$(echo "$manifest_response" | jq -c '[.versions[] | select(.releaseTime | test("-04-01T")) | .id] | reverse')

selected_version=$INPUT_VERSION

if [ "$INPUT_VERSION" == "latest-release" ]; then
  echo "Using latest release version: $latest_release_version"
  selected_version="$latest_release_version"
elif [ "$INPUT_VERSION" == "latest-snapshot" ]; then
  echo "Using latest snapshot version: $latest_snapshot_version"
  selected_version="$latest_snapshot_version"
else
  echo "Using specified version: $INPUT_VERSION"
fi

selected_version_object=$(echo "$manifest_response" | jq -c ".versions[] | select(.id==\"$selected_version\")")

type=$(echo "$selected_version_object" | jq -c '.type')
url=$(echo "$selected_version_object" | jq -c '.url')
time=$(echo "$selected_version_object" | jq -c '.time')
release_time=$(echo "$selected_version_object" | jq -c '.releaseTime')

echo "raw-json=$raw_json" >> "$GITHUB_OUTPUT"
echo "versions=$versions" >> "$GITHUB_OUTPUT"
echo "latest-release-version=$latest_release_version" >> "$GITHUB_OUTPUT"
echo "latest-snapshot-version=$latest_snapshot_version" >> "$GITHUB_OUTPUT"
echo "release-versions=$release_versions" >> "$GITHUB_OUTPUT"
echo "snapshot-versions=$snapshot_versions" >> "$GITHUB_OUTPUT"
echo "april-fools-versions=$april_fools_versions" >> "$GITHUB_OUTPUT"
echo "type=$type" >> "$GITHUB_OUTPUT"
echo "url=$url" >> "$GITHUB_OUTPUT"
echo "time=$time" >> "$GITHUB_OUTPUT"
echo "release-time=$release_time" >> "$GITHUB_OUTPUT"

exit 0
