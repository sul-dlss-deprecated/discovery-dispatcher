[<img src="https://travis-ci.org/sul-dlss/discovery-dispatcher.svg?branch=master" alt="Build Status" />](https://travis-ci.org/sul-dlss/discovery-dispatcher)
[![Coverage Status](https://coveralls.io/repos/sul-dlss/discovery-dispatcher/badge.svg?branch=master)](https://coveralls.io/r/sul-dlss/discovery-dispatcher?branch=master)

#Discovery Dispatcher

This application is responsible for routing the indexing requests for the modified purl public xml objects to the designated indexing services.

## Deployment

```
	git clone https://github.com/sul-dlss/revs-indexer-service.git
	bundle install
	cap [environment] deploy
```

Note: ```config/deploy/example.rb``` has an example of the expected enviroment, the actual values can be found on the configuration control.

## Configuration
The application depends on the following configuration files:

* config/environments/[environment].rb

```config/environments/example.rb``` has an example about the expected fields in the configuration file, the actual values can be found on the configuration control.

* config/targets/[environment].yml

It has a list of the indexing services that the dispatcher need to forward the requests to. ```config/targets/example.yml``` has an example about the expected fields in the configuration file, the actual values can be found on the configuration control.

* config/secrets.yml

## Running tests

```
bundle exec rspec spec
```

Should be run automatically via Travis-CI

## Cronjob
The dispatcher depends on a cron job that is scheduled to run every 15 minutes. You can change the schedule from ```config/schedule.rb```. The cronjob is calling "DiscoveryDispatcher.Monitor.run" to read the updates from purl fetcher server.

## DelayedJob
The dispatcher is using delayed_job as to enequque the upcoming feeds from the purl fetcher. The delayed job process is restarted automatically within each deployment. To restart the delayed_job process manaually, you need to run the following command from the release_directory

```	
	RAILS_ENV=development bundle exec bin/delayed_job stop
	RAILS_ENV=development bundle exec bin/delayed_job start
```

## Manage the application status
The system is expected to run automatically, you can follow the status of the jobs by visiting the following link

  ``` http://server-name/admin/overview ```




