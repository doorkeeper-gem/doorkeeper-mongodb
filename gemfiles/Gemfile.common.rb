ENV['rails'] ||= '4.2'
ENV['doorkeeper'] ||= '4.0'

source 'https://rubygems.org'

gemspec path: '../'

gem 'rails', "~> #{ENV['rails']}"
gem 'doorkeeper', "~> #{ENV['doorkeeper']}"

# Older Grape requires Ruby >= 2.2.2
if ENV['rails'][0] == '4'
  gem 'grape', '~> 0.16', '< 0.19.2'
end
