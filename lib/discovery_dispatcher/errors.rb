module DiscoveryDispatcher
  module Errors
    MissingPurlFetcherIndexPage = Class.new(StandardError)
    MissingPurlFetcherDeletePage = Class.new(StandardError)
  end
end
