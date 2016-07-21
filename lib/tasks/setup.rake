desc "Copy configuration files"
task :config do

  cp("#{Rails.root}/config/targets/example.yml", "#{Rails.root}/config/targets/development.yml") unless File.exists?("#{Rails.root}/config/targets/development.yml")
  cp("#{Rails.root}/config/targets/example.yml", "#{Rails.root}/config/targets/test.yml") unless File.exists?("#{Rails.root}/config/targets/test.yml")
end
