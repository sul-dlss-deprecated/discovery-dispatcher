require 'okcomputer'
require 'uri'

OkComputer.mount_at = 'status' # use /status or /status/all or /status/<name-of-check>
OkComputer.check_in_parallel = true

##
# REQUIRED checks

# Simple echo of the VERSION file
class VersionCheck < OkComputer::AppVersionCheck
  def version
    File.read(Rails.root.join('VERSION')).chomp
  rescue Errno::ENOENT
    raise UnknownRevision
  end
end
OkComputer::Registry.register 'version', VersionCheck.new

# Built-in Sidekiq check
OkComputer::Registry.register 'sidekiq', OkComputer::SidekiqLatencyCheck.new('default')

##
# OPTIONAL checks for external services
#
# These checks will run and report their status, but will not affect the HTTP status code returned.
# We want to be explicit about these external dependencies but not fail on them

# Check to see that purl-fetcher API is live
url = URI.join(Settings.PURL_FETCHER_URL, 'status').to_s
OkComputer::Registry.register 'optional-purl-fetcher', OkComputer::HttpCheck.new(url)

# Check that each of the subtargets has a live service indexer API
Settings.SERVICE_INDEXERS.each do |indexer|
  subtarget = indexer.shift.to_s
  url = indexer.shift.URL.to_s
  OkComputer::Registry.register "optional-#{subtarget}", OkComputer::HttpCheck.new(url)
end

# Indicate that these are all optional checks
OkComputer.make_optional OkComputer::Registry.all.checks.map(&:registrant_name).select { |name| name =~ /^optional/ }
