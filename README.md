# Manifest

## Usage
```yml
jobs:
  manifest:
    runs-on: ubuntu-latest
    name: 'Manifest information'
    steps:
      - name: 'Get Manifest information'
        id: manifest
        uses: MinecraftPlayground/manifest@main
        with:
          version: 'latest-snapshot'

      - name: 'Output'
        run: |
          echo "raw-json: ${{ steps.manifest.outputs.raw-json }}"
          echo "latest-release-version: ${{ steps.manifest.outputs.latest-release-version }}"
          echo "latest-snapshot-version: ${{ steps.manifest.outputs.latest-snapshot-version }}"
          echo "versions: ${{ steps.manifest.outputs.versions }}"
          echo "release-versions: ${{ steps.manifest.outputs.release-versions }}"
          echo "snapshot-versions: ${{ steps.manifest.outputs.snapshot-versions }}"
          echo "april-fools-versions: ${{ steps.manifest.outputs.april-fools-versions }}"
          echo "type: ${{ steps.manifest.outputs.type }}"
          echo "create-time: ${{ steps.manifest.outputs.create-time }}"
          echo "release-time: ${{ steps.manifest.outputs.release-time }}"
          echo "package-url: ${{ steps.manifest.outputs.package-url }}"
          echo "client-download-url: ${{ steps.manifest.outputs.client-download-url }}"
          echo "server-download-url: ${{ steps.manifest.outputs.server-download-url }}"
          echo "asset-index-url: ${{ steps.manifest.outputs.asset-index-url }}"
```

## Inputs
| Key            | Required? | Type     | Default          | Description              |
|----------------|-----------|----------|------------------|--------------------------|
| `version`      | No        | `string` | `latest-release` | Version to get information for.<br><br>Possible values:<ul><li>`latest-snapshot`</li><li>`latest-release`</li><li>`<valid_version>` (ex. `1.21.11` or `26.1-snapshot-1`)</li></ul> |
| `manifest-url` | No        | `string` | `https://piston-meta.mojang.com/mc/game/version_manifest_v2.json` | URL to the manifest API. |

## Outputs
| Key                       | Type       | Description                                                                   |
|---------------------------|------------|-------------------------------------------------------------------------------|
| `raw-json`                | `string`   | The raw manifest file parsed as JSON.                                         |
| `type`                    | `string`   | Type of the version.                                                          |
| `latest-release-version`  | `string`   | The latest release version.                                                   |
| `latest-snapshot-version` | `string`   | The latest snapshot version.                                                  |
| `versions`                | `string[]` | List of all available versions.                                               |
| `release-versions`        | `string[]` | List of all available release versions.                                       |
| `snapshot-versions`       | `string[]` | List of all available snapshot versions.                                      |
| `spril-fools-versions`    | `string[]` | List of all available april fools versions.                                   |
| `create-time`             | `string`   | Time when the version was created/uploaded. (Based on the input `version`)    |
| `release-time`            | `string`   | Time when the version was officially released. (Based on the input `version`) |
| `package-url`             | `string`   | Package URL of the version. (Based on the input `version`)                    |
| `client-download-url`     | `string`   | URL to download the client. (Based on the input `version`)                    |
| `server-download-url`     | `string`   | URL to download the server. (Based on the input `version`)                    |
| `asset-index-url`         | `string`   | URL thats points to the assets. (Based on the input `version`)                |
