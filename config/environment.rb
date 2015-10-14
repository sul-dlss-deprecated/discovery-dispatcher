# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

class SimpleFormatter < ::Logger::Formatter
  # This method is invoked when a log event occurs
  def call(severity, timestamp, progname, msg)
    date_format = timestamp.strftime('%Y-%m-%d %H:%M:%S')
    "[#{date_format}] #{severity} (#{progname}): #{msg}\n"
  end
end
