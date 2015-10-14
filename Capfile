# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'
require 'dlss/capistrano'
require 'whenever/capistrano'
require 'capistrano/passenger'

require 'capistrano/bundler'
require 'capistrano/rails'
# load 'deploy/assets'

require 'squash/rails/capistrano3'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
