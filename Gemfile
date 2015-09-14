source 'https://rubygems.org'

gem 'rails', '4.1.11'
gem 'mysql2', '~> 0.3.13'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer',  platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'spring',        group: :development
gem 'coveralls', require: false

# Application specific gems
gem 'delayed_job_active_record'
gem 'rest-client'
gem 'yard'
gem 'daemons'
gem 'whenever', :require => false
gem "delayed_job_web"
gem 'is_it_working-cbeer'

group :development, :test do
  gem "rspec"
  gem 'rspec-rails', '~> 3.0'
  gem 'sqlite3'
  gem 'vcr'
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
