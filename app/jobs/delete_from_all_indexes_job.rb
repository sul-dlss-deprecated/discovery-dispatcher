# A special type of indexing job that builds the correct URL for the API to
# delete from all subtargets
class DeleteFromAllIndexesJob < IndexingJob
  # @param druid [String] represents the druid on the form of ab123cd4567
  # @param target_url [String] the url for the indexing service
  # @param _solr_target [Array] solr target for solr core (not used as we are
  # deleting from all subtargets)
  # @return [String] RestClient request command
  def build_request_url(druid, target_url, _solr_target)
    "#{target_url}/items/#{druid}"
  end
end
