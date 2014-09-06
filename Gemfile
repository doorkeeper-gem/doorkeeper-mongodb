source "https://rubygems.org"

gem 'doorkeeper', github: 'jasl/doorkeeper', branch: 'extract-orm-specifics'

# Defaults. For supported versions check .travis.yml
ENV['orm']   ||= 'mongoid4'
ENV['rails'] ||= ENV['orm'] == 'mongoid4' ? '~> 4.1.2' : '~> 3.2.13'

gem 'rails', ENV['rails']

case ENV['orm']
when 'active_record'
  gem 'activerecord'

when 'mongoid2'
  gem 'mongoid', '~> 2'

when 'mongoid3'
  gem 'mongoid', '~> 3'

when 'mongoid4'
  gem 'mongoid', '~> 4'

when 'mongo_mapper'
  gem 'mongo_mapper', '~> 0'
end

gemspec
