gemfile = File.expand_path("../Gemfile.common.rb", __FILE__)
instance_eval IO.read(gemfile), gemfile

gem 'mongoid', '~> 6'
