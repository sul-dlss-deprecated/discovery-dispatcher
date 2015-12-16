# Read the target list automatically from the registered services
Rails.configuration.target_urls_hash = DiscoveryDispatcher::ServiceTargetsReader.instance.targets_urls
