# Releases API

> [Introduced](https://gitlab.com/gitlab-org/gitlab-ce/issues/41766) in GitLab 11.7.

Releases mark specific points in a project's development history, communicate
information about the type of change, and deliver on prepared, often compiled,
versions of the software to be reused elsewhere.

You can also [create releases via the GitLab UI](../user/project/releases.md).

## List releases

Paginated list of releases, sorted by `created_at`.

```
GET /projects/:id/releases
```

| Attribute     | Type           | Required | Description                             |
| ------------- | -------------- | -------- | --------------------------------------- |
| `id`          | integer/string | yes      | The ID or [URL-encoded path of the project](README.md#namespaced-path-encoding). |

Example request:

```sh
curl --header "PRIVATE-TOKEN: 9koXpg98eAheJpvBs5tK" "https://gitlab.example.com/api/v4/"
```

Example response:

## Get a release by a tag name

Get a release for the given tag.

```
GET /projects/:id/release/:tag_name
```

| Attribute     | Type           | Required | Description                             |
| ------------- | -------------- | -------- | --------------------------------------- |
| `id`          | integer/string | yes      | The ID or [URL-encoded path of the project](README.md#namespaced-path-encoding). |
| `tag_name`    | string         | yes      | The tag where the release will be created from. |

Example request:

```sh
curl --header "PRIVATE-TOKEN: 9koXpg98eAheJpvBs5tK" "https://gitlab.example.com/api/v4/"
```

Example response:

```json
{
}
```

## Create a release

Create a release. You need push access to the repository to create a release.

```
POST /projects/:id/releases
```

| Attribute     | Type           | Required | Description                             |
| ------------- | -------------- | -------- | --------------------------------------- |
| `id`          | integer/string | yes      | The ID or [URL-encoded path of the project](README.md#namespaced-path-encoding). |
| `name`        | string         | yes      | The release name.                       |
| `tag_name`    | string         | no       | The tag where the release will be created from. |
| `description` | string         | no       | The description of the release. You can use [markdown](../user/markdown.md). |
| `ref`         | string         | yes      | If `tag_name` doesn't exist, the release will be created from `ref`. It can be a commit SHA, another tag name, or a branch name. |
| `assets`      | array          | yes      | An array with assets links.                  |

Example request:

```sh
curl --request POST --header "PRIVATE-TOKEN: 9koXpg98eAheJpvBs5tK" "https://gitlab.example.com/api/v4/"
```

Example response:

```json
{
  "name": "Bionic Beaver",
  "tag_name": "18.04",
  "description": "## changelog\n\n* line 1\n* line2",
  "ref": "stable-18-04",
  "assets": {
    "links": [
      {
         "name": "release-18.04.dmg",
         "url": "https://my-external-hosting.example.com/scrambled-url/"
      },
      {
         "name": "binary-linux-amd64",
         "url": "https://gitlab.com/gitlab-org/gitlab-ce/-/jobs/artifacts/v11.6.0-rc4/download?job=rspec-mysql+41%2F50"
      }
    ]
  }
}
```

## Update a release

Update a release.

```
PUT /projects/:id/release/:tag_name
```

| Attribute     | Type           | Required | Description                             |
| ------------- | -------------- | -------- | --------------------------------------- |
| `id`          | integer/string | yes      | The ID or [URL-encoded path of the project](README.md#namespaced-path-encoding). |
| `name`        | string         | yes      | The release name.                       |
| `tag_name`    | string         | no       | The tag where the release will be created from. |
| `description` | string         | no       | The description of the release. You can use [markdown](../user/markdown.md). |
| `ref`         | string         | yes      | If `tag_name` doesn't exist, the release will be created from `ref`. It can be a commit SHA, another tag name, or a branch name. |
| `assets`      | array          | yes      | An array with assets links.                  |

Example request:

```sh
curl --request PUT --header "PRIVATE-TOKEN: 9koXpg98eAheJpvBs5tK" "https://gitlab.example.com/api/v4/"
```

Example response:

```json
{
}
```

## Delete a release

Delete a release. Deleting a release will not delete the associated tag.

```
DELETE /projects/:id/release/:tag_name
```

| Attribute     | Type           | Required | Description                             |
| ------------- | -------------- | -------- | --------------------------------------- |
| `id`          | integer/string | yes      | The ID or [URL-encoded path of the project](README.md#namespaced-path-encoding). |
| `tag_name`    | string         | no       | The tag where the release will be created from. |

Example request:

```sh
curl --request DELETE --header "PRIVATE-TOKEN: 9koXpg98eAheJpvBs5tK" "https://gitlab.example.com/api/v4/"
```

Example response:

```json
{
}
```
