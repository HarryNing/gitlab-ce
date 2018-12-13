# Project traffic API

Every API call to project traffics must be authenticated.

## Get the http clones of the last 30 days

Retrieving the clone statistics requires write access to the repository.

```
GET /projects/:id/traffic/fetches
```

| Attribute  | Type   | Required | Description |
| ---------- | ------ | -------- | ----------- |
| `id `      | integer / string | yes      | The ID or [URL-encoded path of the project](README.md#namespaced-path-encoding) |

Example response:

```json
[
  count: 50,
  fetches: [
    {
      date: '2018-01-10',
      count: 10
    },
    {
      date: '2018-01-9',
      count: 10
    },
    {
      date: '2018-01-8',
      count: 10
    },
    {
      date: '2018-01-7',
      count: 10
    },
    {
      date: '2018-01-6',
      count: 10
    }
  ]
]
```
