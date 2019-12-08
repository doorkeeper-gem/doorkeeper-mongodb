gemfile = File.expand_path('../Gemfile.common.rb', __FILE__)
instance_eval IO.read(gemfile), gemfile

gem 'actionpack', '~> 6.0', '>= 6.0.1'
gem 'bcrypt', '~> 3.1', '>= 3.1.11'
gem 'activemodel', '~> 5.2', '< 6'
gem 'mongoid', '~> 6'
