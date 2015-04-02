Rails.application.config.target_urls = YAML.load(Rails.root.join('config','targets', "#{Rails.env}.yml").to_s)

