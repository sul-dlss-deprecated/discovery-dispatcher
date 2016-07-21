source 'https://rubygems.org'

gem 'rails', '~> 4.2' # specifying because we expect a major version upgrade to break things

# Pinned to 1.3.3 until https://github.com/SquareSquash/rails/pull/15
gem 'squash_rails', '1.3.3', require: 'squash/rails'

# Application specific gems
gem 'daemons' # TODO: where is this used?
gem 'delayed_job_active_record'
gem 'delayed_job_web'
gem 'faraday'
gem 'is_it_working-cbeer'
gem 'jbuilder' # TODO: where is this used?
gem 'rake' # needed for automation tasks
gem 'responders' # TODO: where is this used?
gem 'rest-client'
gem 'whenever', require: false

group :development, :test do
  gem 'dlss_cops'
  gem 'sdoc'
  gem 'spring'
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
  gem 'vcr'
  gem 'webmock'
end

group :deployment do
  gem 'dlss-capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano3-delayed-job'
end
