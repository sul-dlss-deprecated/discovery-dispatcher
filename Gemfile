source 'https://rubygems.org'

gem 'rails', '~> 5.2.0'

# Use Puma as the app server
gem 'puma', '~> 3.11'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

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
end

group :production do
  gem 'mysql2'
  gem 'newrelic_rpm'
end

group :test do
  gem 'simplecov'
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
