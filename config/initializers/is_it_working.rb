require 'is_it_working'
Rails.configuration.middleware.use(IsItWorking::Handler) do |h|
  h.check :active_record, :async => false
  h.check :url, :get =>  "#{Rails.configuration.purl_fetcher_url}/is_it_working"
end