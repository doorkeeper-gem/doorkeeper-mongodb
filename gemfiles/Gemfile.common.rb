ENV['RAILS'] ||= '4.2'
ENV['DOORKEEPER'] ||= '4.4'

source 'https://rubygems.org'

gemspec path: '../'

gem 'rails', "~> #{ENV['RAILS']}"
gem 'doorkeeper', "~> #{ENV['DOORKEEPER']}"

# Older Grape requires Ruby >= 2.2.2
if ENV['RAILS'][0] == '4'
  gem 'grape', '~> 0.16', '< 0.19.2'
end
