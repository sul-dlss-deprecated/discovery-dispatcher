module PurlFetcher
  class Client

    ##
    # @return [Hash] a parsed JSON hash
    def get(path, params = {})
      connection.get(path) do |req|
        req.params = params
      end.body
    end

    ##
    # For performance, and enumberable object is returned.
    #
    # @example operating on each of the results as they come in
    #   paginated_get('/docs/changes', 'changes').map { |v| puts v.inspect }
    #
    # @example getting all of the results and converting to an array
    #   paginated_get('/docs/changes', 'changes').to_a
    #
    # @return [Enumerator] an enumberable object
    def paginated_get(path, accessor, options = {})
      Enumerator.new do |yielder|
        params   = options.dup
        per_page = params.delete(:per_page) { 100 }
        page     = params.delete(:page) { 1 }
        max      = params.delete(:max) { 1_000_000 }
        total    = 0

        loop do
          data = get(path, { per_page: per_page, page: page }.merge(params))

          total += data[accessor].length

          data[accessor].each do |element|
            yielder.yield element
          end

          page += 1

          break if data['pages']['last_page?'] || total >= max
        end
      end
    end

    private

    ##
    # @return [Faraday::Connection]
    def connection
      @connection ||= begin
        conn = Faraday.new(url: Settings.PURL_FETCHER_URL) do |faraday|
          # Adding the FaradayMiddleware with the response set as :json, will
          # auto parse the response as JSON to a Hash
          faraday.response :json

          faraday.adapter Faraday.default_adapter
        end
        conn.options.timeout = 60 # the purl-fetcher API can be a bit slow
        conn.options.open_timeout = 10
        conn
      end
    end
  end
end
