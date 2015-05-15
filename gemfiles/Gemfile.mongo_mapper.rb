gemfile = File.expand_path("../Gemfile.common.rb", __FILE__)
instance_eval IO.read(gemfile), gemfile

gem 'mongo_mapper'
gem 'bson_ext'
