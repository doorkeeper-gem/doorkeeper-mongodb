gemfile = File.expand_path('../Gemfile.common.rb', __FILE__)
instance_eval IO.read(gemfile), gemfile

gem 'activemodel', '~> 5.2', '< 6'
gem 'mongoid', '~> 6'
