#!/bin/sh

# Global inputs:
# 
# $INPUT_VERSION
# $INPUT_MANIFEST_URL
# $INPUT_RESOURCES_URL

# Global outputs:
#
# versions
# latest-release-version
# latest-snapshot-version
# release-versions
# snapshot-versions
# spril-fools-versions

manifest_response=$(curl -L $INPUT_MANIFEST_URL)

echo "$manifest_response"

versions=$(echo "$manifest_response" | jq -r '.versions[].id')
latest_release_version=$(echo "$manifest_response" | jq -r '.latest.release')
latest_snapshot_version=$(echo "$manifest_response" | jq -r '.latest.snapshot')

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

exit 0
