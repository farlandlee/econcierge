# Grid

[![Build Status](https://travis-ci.com/outpostjh/grid.svg?token=pM1BoXzsi31ng6qGE9fY)](https://travis-ci.com/outpostjh/grid)

## Installation

*Installing this application requires `elixir`, `node`, `npm`, `postgres` on your system.*

```sh
$ npm install      # Install asset build tools
$ mix deps.get     # Install application dependencies
$ mix ecto.create  # Create database
$ mix ecto.migrate # Run migrations
```

## Developing

  1. Start Phoenix endpoint with `mix phoenix.server`, or `iex -S mix phoenix.server` for the interactive shell.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Testing

  1. `mix test`

## Phoenix Links

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Production Environment variables

ENV Variable  | Description                                                 |
------------- | ----------------------------------------------------------- |
DATABASE_URL  | Database connection url, e.g. postgres://un:pw@host:port/db |
