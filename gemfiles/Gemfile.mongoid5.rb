gemfile = File.expand_path('../Gemfile.common.rb', __FILE__)
instance_eval IO.read(gemfile), gemfile

gem 'activemodel', '~> 4.0', '< 5'
gem 'mongoid', '~> 5'
