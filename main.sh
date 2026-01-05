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

versions=$($manifest_response | jq -r '.versions')
latest_release_version=$($manifest_response | jq -r '.latest.release')
latest_snapshot_version=$($manifest_response | jq -r '.latest.snapshot')

if [ "$INPUT_VERSION" == "latest-snapshot" ]; then
  echo "Fetching the latest snapshot version."
  latest_version=$($manifest_response | jq -r '.latest.snapshot')

  if [ -z "$latest_version" ]; then
    echo "Error: Could not find the latest snapshot version in the manifest."
    exit 1
  fi

  echo "Using latest snapshot version: $latest_version"
  INPUT_VERSION="$latest_version"

elif [ "$INPUT_VERSION" == "latest-release" ]; then
  echo "Fetching the latest release version."
  latest_version=$($manifest_response | jq -r '.latest.release')

  if [ -z "$latest_version" ]; then
    echo "Error: Could not find the latest release version in the manifest."
    exit 1
  fi

  echo "Using latest release version: $latest_version"
  INPUT_VERSION="$latest_version"

else
  echo "Using specified version: $INPUT_VERSION"
fi

echo "versions=$versions" >> "$GITHUB_OUTPUT"
echo "latest-release-version=$latest_release_version" >> "$GITHUB_OUTPUT"
echo "latest-snapshot-version=$latest_snapshot_version" >> "$GITHUB_OUTPUT"

exit 0
