[![Build Status](https://travis-ci.org/sul-dlss/discovery-dispatcher.svg?branch=master)](https://travis-ci.org/sul-dlss/discovery-dispatcher) [![Coverage Status](https://coveralls.io/repos/sul-dlss/discovery-dispatcher/badge.svg?branch=master)](https://coveralls.io/r/sul-dlss/discovery-dispatcher?branch=master) [![Dependency Status](https://gemnasium.com/sul-dlss/discovery-dispatcher.svg)](https://gemnasium.com/sul-dlss/discovery-dispatcher)

# Discovery Dispatcher

Uses the [purl-fetcher](https://github.com/sul-dlss/purl-fetcher) API
to dispatch publication events to indexing services, such as [sw-indexer](https://github.com/sul-dlss/sw-indexer).

## Deployment

To deploy the application, use:

```bash
git clone https://github.com/sul-dlss/discovery-dispatcher.git
cd discovery-dispatcher
bundle install
bundle exec cap [environment] deploy
```

## Configuration

Configuration is handled using the [config](https://github.com/railsconfig/config) gem. Per server settings are stored in shared_configs using normalized DLSS practices.


## Sidekiq

We provide a basic jobs management UI -- go to `/`.

To query purl-fetcher for new jobs to enqueue, use:

```bash
rake discovery_dispatcher:query_purl_fetcher
```

Note that `config/schedule.rb` will run this command automatically in deployed environments.

To restart the background processes, use:

```bash
cap [environment] sidekiq:restart
```

## Development

To setup your development environment, use:

```bash
rake db:migrate
RAILS_ENV=test rake db:migrate
```

## Running tests

```bash
rake spec
```

## Starting server

```bash
rails s
```
