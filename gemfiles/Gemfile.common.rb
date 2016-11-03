ENV['rails'] ||= '4.2.0'
ENV['doorkeeper'] ||= '3.0.0'

source 'https://rubygems.org'

gemspec path: '../'

gem 'rails', "~> #{ENV['rails']}"
gem 'doorkeeper', "~> #{ENV['doorkeeper']}", github: 'doorkeeper-gem/doorkeeper'
