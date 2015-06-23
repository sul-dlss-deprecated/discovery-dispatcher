# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

require 'rake'
require 'bundler'

require 'yard'
require 'yard/rake/yardoc_task'

# Executed by the following command 
# cd /opt/app/lyberadmin/discovery-dispatcher/current && bundle exec rake RAILS_ENV=development discovery_dispatcher:query_purl_fetcher
namespace :discovery_dispatcher do
  task query_purl_fetcher: :environment do
    DiscoveryDispatcher::Monitor.run
    File.open("log/query_purl_fetcher.log", 'a') { |f| f.write("Read the new updated items in Purl fetcher at #{Time.now}\n") }
  end
end

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

task :default => :ci  

desc "run continuous integration suite (tests, coverage, docs)" 
task :ci => [:spec, :doc]

# Use yard to build docs
begin
  project_root = File.expand_path(File.dirname(__FILE__))
  doc_dest_dir = File.join(project_root, 'doc')

  YARD::Rake::YardocTask.new(:doc) do |yt|
    yt.files = Dir.glob(File.join(project_root, 'lib', '**', '*.rb')) +
                 [ File.join(project_root, 'README.rdoc') ]
    yt.options = ['--output-dir', doc_dest_dir, '--readme', 'README.rdoc', '--title', 'Discovery Dispatcher Documentation']
  end
rescue LoadError
  desc "Generate YARD Documentation"
  task :doc do
    abort "Please install the YARD gem to generate rdoc."
  end
end  