# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

# Executed by the following command 
# cd /...//discovery-dispatcher/current && bundle exec rake RAILS_ENV=development discovery_dispatcher:query_purl_fetcher
namespace :discovery_dispatcher do
  task query_purl_fetcher: :environment do
    puts "Read the new updated items in Purl fetcher"
    DiscoveryDispatcher::Monitor.run
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
task :ci => [:rspec, :doc]

task :spec => :rspec

RSpec::Core::RakeTask.new(:rspec) do |spec|
  spec.rspec_opts = ["-c", "-f progress", "--tty", "-r ./spec/spec_helper.rb"]
end

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