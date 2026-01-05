#!/bin/sh

# Global inputs:
# 
# $INPUT_VERSION
# $INPUT_MANIFEST_URL
# $INPUT_IF_VERSION_IS_INVALID

# Global outputs:
#
# raw-json
# type
# latest-release-version
# latest-snapshot-version
# java-version
# versions
# release-versions
# snapshot-versions
# april-fools-versions
# package-url
# create-time
# release-time
# client-download-url
# server-download-url
# asset-index-url

manifest_response=$(curl -fsSL "$INPUT_MANIFEST_URL") || {
  echo "::error::Fetch Failed: Could not fetch manifest"
  exit 1
}

raw_json="$manifest_response"
latest_release_version=$(echo "$manifest_response" | jq -r '.latest.release')
latest_snapshot_version=$(echo "$manifest_response" | jq -r '.latest.snapshot')
versions=$(echo "$manifest_response" | jq -c '[.versions[].id] | reverse')
release_versions=$(echo "$manifest_response" | jq -c '[.versions[] | select(.type=="release") | .id] | reverse')
snapshot_versions=$(echo "$manifest_response" | jq -c '[.versions[] | select(.type=="snapshot") | .id] | reverse')
april_fools_versions=$(echo "$manifest_response" | jq -c '[.versions[] | select(.releaseTime | test("-04-01T")) | .id] | reverse')

selected_version=$INPUT_VERSION

if [ "$INPUT_VERSION" = "latest-release" ] || [ -z "$INPUT_VERSION" ]; then
  echo "Using latest release version: $latest_release_version"
  selected_version="$latest_release_version"
elif [ "$INPUT_VERSION" == "latest-snapshot" ]; then
  echo "Using latest snapshot version: $latest_snapshot_version"
  selected_version="$latest_snapshot_version"
else
  echo "Using specified version: $INPUT_VERSION"
fi

selected_version_object=$(echo "$manifest_response" | jq -c ".versions[] | select(.id==\"$selected_version\")")

if [ -z "$selected_version_object" ]; then
  case "$INPUT_IF_VERSION_IS_INVALID" in
    warn)
      echo "::warning::Invalid Version: Falling back to latest release ($latest_release_version)" >&2
      selected_version="$latest_release_version"
      selected_version_object=$(echo "$manifest_response" | jq -c ".versions[] | select(.id==\"$selected_version\")")
      ;;
    ignore)
      selected_version="$latest_release_version"
      selected_version_object=$(echo "$manifest_response" | jq -c ".versions[] | select(.id==\"$selected_version\")")
      ;;
    error)
      echo "::error::Invalid Version: Failing" >&2
      exit 1
      ;;
    *)
      echo "::error::Invalid Parameter: Invalid value for parameter 'if-version-is-invalid': $INPUT_IF_VERSION_IS_INVALID" >&2
      exit 1
      ;;
  esac
fi

type=$(echo "$selected_version_object" | jq -r '.type')
package_url=$(echo "$selected_version_object" | jq -r '.url')
create_time=$(echo "$selected_version_object" | jq -r '.time')
release_time=$(echo "$selected_version_object" | jq -r '.releaseTime')

package_url_response=$(curl -fsSL "$package_url") || {
  echo "::error::Fetch Failed: Could not fetch package JSON"
  exit 1
}

client_download_url=$(echo "$package_url_response" | jq -r '.downloads.client.url')
server_download_url=$(echo "$package_url_response" | jq -r '.downloads.server.url')
asset_index_url=$(echo "$package_url_response" | jq -r '.assetIndex.url')
java_version=$(echo "$package_url_response" | jq -r '.javaVersion.majorVersion')

echo "raw-json=$raw_json" >> "$GITHUB_OUTPUT"
echo "versions=$versions" >> "$GITHUB_OUTPUT"
echo "latest-release-version=$latest_release_version" >> "$GITHUB_OUTPUT"
echo "latest-snapshot-version=$latest_snapshot_version" >> "$GITHUB_OUTPUT"
echo "java-version=$java_version" >> "$GITHUB_OUTPUT"
echo "release-versions=$release_versions" >> "$GITHUB_OUTPUT"
echo "snapshot-versions=$snapshot_versions" >> "$GITHUB_OUTPUT"
echo "april-fools-versions=$april_fools_versions" >> "$GITHUB_OUTPUT"
echo "type=$type" >> "$GITHUB_OUTPUT"
echo "package-url=$package_url" >> "$GITHUB_OUTPUT"
echo "create-time=$create_time" >> "$GITHUB_OUTPUT"
echo "release-time=$release_time" >> "$GITHUB_OUTPUT"
echo "client-download-url=$client_download_url" >> "$GITHUB_OUTPUT"
echo "server-download-url=$server_download_url" >> "$GITHUB_OUTPUT"
echo "asset-index-url=$asset_index_url" >> "$GITHUB_OUTPUT"

exit 0
