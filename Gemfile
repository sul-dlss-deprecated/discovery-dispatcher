source 'https://rubygems.org'

gem 'rails', '~> 5.1.0'

# Use Puma as the app server
gem 'puma', '~> 3.7'
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
gem 'honeybadger'
gem 'sidekiq'

group :development, :test do
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'sdoc'
  gem 'sqlite3'
  gem 'yard'
  gem 'listen', '>= 3.0.5', '< 3.2'
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
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano-sidekiq'
end
