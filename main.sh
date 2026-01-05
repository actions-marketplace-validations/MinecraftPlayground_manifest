#!/bin/sh

# Global inputs:
# 
# $INPUT_VERSION
# $INPUT_MANIFEST_URL
# $INPUT_RESOURCES_URL

# Global outputs:
#
# latest-release-version
# latest-snapshot-version
# versions
# release-versions
# snapshot-versions
# april-fools-versions

manifest_response=$(curl -L $INPUT_MANIFEST_URL)

echo "$manifest_response"

latest_release_version=$(echo "$manifest_response" | jq -r '.latest.release')
latest_snapshot_version=$(echo "$manifest_response" | jq -r '.latest.snapshot')
versions=$(echo "$manifest_response" | jq -c '[.versions[].id] | reverse')
release_versions=$(echo "$manifest_response" | jq -c '[.versions[] | select(.type=="release") | .id] | reverse')
snapshot_versions=$(echo "$manifest_response" | jq -c '[.versions[] | select(.type=="snapshot") | .id] | reverse')

if [ "$INPUT_VERSION" == "latest-release" ]; then
  echo "Using latest release version: $latest_release_version"
  INPUT_VERSION="$latest_release_version"
elif [ "$INPUT_VERSION" == "latest-snapshot" ]; then
  echo "Using latest snapshot version: $latest_snapshot_version"
  INPUT_VERSION="$latest_snapshot_version"
else
  echo "Using specified version: $INPUT_VERSION"
fi

echo "versions=$versions" >> "$GITHUB_OUTPUT"
echo "latest-release-version=$latest_release_version" >> "$GITHUB_OUTPUT"
echo "latest-snapshot-version=$latest_snapshot_version" >> "$GITHUB_OUTPUT"
echo "release-versions=$release_versions" >> "$GITHUB_OUTPUT"
echo "snapshot-versions=$snapshot_versions" >> "$GITHUB_OUTPUT"
echo "april-fools-versions=$april_fools_versions" >> "$GITHUB_OUTPUT"

exit 0
