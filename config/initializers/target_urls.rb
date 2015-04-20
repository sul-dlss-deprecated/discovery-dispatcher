Rails.application.config.target_urls = YAML.load(File.new(Rails.root.join('config','targets', "#{Rails.env}.yml").to_s))

