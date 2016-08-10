module PurlFetcher
  ##
  # API accessor for the Purl-Fetcher service
  class API

    ##
    # @return [Enumerator]
    def changes(params = {})
      client.paginated_get('/docs/changes', 'changes', params)
    end

    ##
    # @return [Enumerator]
    def deletes(params = {})
      client.paginated_get('/docs/deletes', 'deletes', params)
    end

    private

    def client
      @client ||= PurlFetcher::Client.new
    end
  end
end
