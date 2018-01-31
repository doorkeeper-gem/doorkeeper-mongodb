ENV['rails'] ||= '4.2'
ENV['doorkeeper'] ||= '4.0'

source 'https://rubygems.org'

gemspec path: '../'

gem 'rails', "~> #{ENV['rails']}"
gem 'doorkeeper', "~> #{ENV['doorkeeper']}"
