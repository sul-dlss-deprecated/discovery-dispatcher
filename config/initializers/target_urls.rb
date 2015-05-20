# Read the target list automatically from the registered services
Rails.configuration.targets_url_hash = DiscoveryDispatcher::TargetsReader.instance.read_targets_from_service
