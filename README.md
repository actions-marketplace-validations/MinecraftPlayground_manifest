# manifest

## Inputs

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
