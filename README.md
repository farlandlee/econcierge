# Grid

[![Build Status](https://travis-ci.com/outpostjh/grid.svg?token=pM1BoXzsi31ng6qGE9fY)](https://travis-ci.com/outpostjh/grid)

## Useful Links

- [Invision Mocks](https://projects.invisionapp.com/share/3E5XNSPY2)
- [Design Docs](https://www.lucidchart.com/documents/edit/099b9222-c340-48ed-a5fe-b9a2c60176cf/0?shared=true)
- [Staging Site](http://outpost-grid.herokuapp.com/)
- [Rollbar](https://rollbar.com/Outpost/Grid/)

## Installation

### Prerequisites

Installing this application requires the following in your system path

- `elixir` (`brew update && brew install elixir`)
- `postgres`
* [Git](http://git-scm.com/)
* [Node.js](http://nodejs.org/) (with NPM)
* [Bower](http://bower.io/)
* [Ember CLI](http://www.ember-cli.com/) (only required if you're running the ember app in development mode)
* [PhantomJS](http://phantomjs.org/)

### Commands

```sh
$ mix deps.client  # Install asset build tools
$ mix deps.get     # Install application dependencies
$ mix ecto.create  # Create database
$ mix ecto.migrate # Run migrations
```

## Developing

  1. Start Phoenix endpoint with `mix s`, or `iex -S mix s` for the interactive shell.
  This will run both ember and brunch in "watch" modes.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Generators

```sh
$ mix help | grep gen # Print useful phoenix and ecto code generators.
$ mix ecto.gen.migration
$ mix phoenix.gen.html
/client$ ember g --help
/client$ ember g component
/client$ ember g route
```

## Testing

  1. `mix test`

## Useful Links

** Phoenix **

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

** Ember **

  * [ember.js](http://emberjs.com/)
  * [ember-cli](http://www.ember-cli.com/)
  * Development Browser Extensions
  * [ember inspector for chrome](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi)
  * [ember inspector for firefox](https://addons.mozilla.org/en-US/firefox/addon/ember-inspector/)


## Environment variables

ENV Variable           | Description                   |
---------------------- | ----------------------------- |
AWS_ACCESS_KEY         | AWS Access Key for S3 buckets |
AWS_SECRET_KEY         | AWS Secret Key for S3 buckets |
GOOGLE_CLIENT_ID       | Google API Client Id          |
GOOGLE_CLIENT_SECRET   | Google Client Secret          |

### Production-only

ENV Variable            | Description                                                 |
----------------------- | ----------------------------------------------------------- |
DATABASE_URL            | Database connection url, e.g. postgres://un:pw@host:port/db |
POSTMARK_SERVER_TOKEN   | Postmark Server Token                                       |
TRIPADVISOR_API_KEY     | TripAdvisor api key                                         |
