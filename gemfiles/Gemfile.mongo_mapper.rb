gemfile = File.expand_path("../Gemfile.common.rb", __FILE__)
instance_eval IO.read(gemfile), gemfile

gem 'mongo_mapper'
gem 'bson_ext'

# Rails >= 5
if ENV['rails'][0].to_i >= 5
  gem 'activemodel-serializers-xml'
end
