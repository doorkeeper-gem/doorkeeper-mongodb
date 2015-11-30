ENV['rails'] ||= '4.2.0'

source 'https://rubygems.org'

gemspec path: '../'

gem 'rails', "~> #{ENV['rails']}"
gem 'doorkeeper', '~> 3.0.0', github: 'doorkeeper-gem/doorkeeper'
