source 'https://rubygems.org'

gem 'rails'
gem 'responders'
gem 'mysql2'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder'
gem 'sdoc', group: :doc
gem 'spring', group: :development
gem 'coveralls', require: false
gem 'faraday'

# Use Squash for exception reporting
gem 'squash_ruby', require: 'squash/ruby'

# Pinned to 1.3.3 until https://github.com/SquareSquash/rails/pull/15
gem 'squash_rails', '1.3.3', require: 'squash/rails'

# Application specific gems
gem 'delayed_job_active_record'
gem 'rest-client'
gem 'yard'
gem 'daemons'
gem 'whenever', require: false
gem 'delayed_job_web'
gem 'is_it_working-cbeer'

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'sqlite3'
  gem 'vcr'
  gem 'dlss_cops'
end

group :test do
  gem 'webmock'
end

group :deployment do
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'dlss-capistrano'
  gem 'capistrano-passenger'
end
