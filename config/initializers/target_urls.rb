# Read the target list automatically from the registered services
Rails.configuration.targets_url_hash = DiscoveryDispatcher::ServiceTargetsReader.instance.read_service_targets
