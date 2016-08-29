source 'https://rubygems.org'

gem 'rails', '~> 4.2' # specifying because we expect a major version upgrade to break things

# Application specific gems
gem 'config'
gem 'daemons' # TODO: where is this used?
gem 'faraday'
gem 'faraday_middleware'
gem 'okcomputer' # for monitoring
gem 'jbuilder' # TODO: where is this used?
gem 'rake' # needed for automation tasks
gem 'responders' # TODO: where is this used?
gem 'rest-client'
gem 'whenever', require: false
gem 'honeybadger', '~> 2.0'
gem 'sidekiq'

group :development, :test do
  gem 'dlss_cops'
  gem 'sdoc'
  gem 'sqlite3'
  gem 'yard'
end

group :production do
  gem 'mysql2'
end

group :test do
  gem 'coveralls', require: false
  gem 'rspec-rails'
  gem 'rspec'
  gem 'webmock'
end

group :deployment do
  gem 'dlss-capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-sidekiq'
end
