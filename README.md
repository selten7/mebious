# mebious.wired

A clone of [Mebby](http://mebious.co.uk) written in Ruby using the
Sinatra framework.

## Overview of the data API

`mebious.wired` uses a RESTful API to facilitate the development of
third party interfaces with read/write access to the central database.

Unless otherwise explicitly stated, the `POST` requests must have a
`Content-Type: application/x-www-form-urlencoded` header, and their body
must be formatted accordingly.

| Method | Endpoint | Request body | Response body | Description |
|---|---|---|---|---|
| `GET` | `/posts` | - | `Array<Post>` | Return an array of objects representing the last 20 posts. |
| `GET` | `/posts/:n` | - | `Array<Post>` | Return an array of objects representing the last `n` posts. |
| `POST` | `/api/:apikey` | `CreatePost` | - | Create a post. |

### `Post` model

| Field | Type | Description |
|---|---|---|
| `id` | `Number` | - |
| `text` | `String` | - |
| `spawn` | `Number` | - |
| `is_admin` | `Number` | - |

### `CreatePost` model

| Field | Type | Description |
|---|---|---|
| `text` | `String` | Content of the post. |

## License

MIT
