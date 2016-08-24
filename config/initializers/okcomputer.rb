require 'okcomputer'

OkComputer.mount_at = 'status'
OkComputer.check_in_parallel = true

# Check to see that purl-fetcher API is live
OkComputer::Registry.register 'purl-fetcher', OkComputer::HttpCheck.new("#{Settings.PURL_FETCHER_URL}/is_it_working")

# Check that each of the subtargets has a live service indexer API
Settings.SERVICE_INDEXERS.each do |indexer|
  subtarget = indexer.shift.to_s
  url = indexer.shift.URL
  OkComputer::Registry.register subtarget, OkComputer::HttpCheck.new(url)
end

# Simple echo of the VERSION file
class VersionCheck < OkComputer::AppVersionCheck
  def version
    File.read(Rails.root.join('VERSION')).chomp
  rescue Errno::ENOENT
    raise UnknownRevision
  end
end
OkComputer::Registry.register 'version', VersionCheck.new
