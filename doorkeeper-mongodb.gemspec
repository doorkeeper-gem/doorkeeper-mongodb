# frozen_string_literal: true
$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'doorkeeper-mongodb/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|
  gem.name        = 'doorkeeper-mongodb'
  gem.version     = DoorkeeperMongodb.gem_version
  gem.authors     = ['jasl', 'Nikita Bulai']
  gem.email       = ['bulaj.nikita@gmail.com']
  gem.homepage    = 'http://github.com/doorkeeper-gem/doorkeeper-mongodb'
  gem.summary     = 'Doorkeeper mongoid and mongo_mapper ORMs'
  gem.description = 'Doorkeeper mongoid and mongo_mapper ORMs'
  gem.license     = 'MIT'

  gem.files      = Dir['lib/**/*', 'config/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  gem.test_files = Dir['spec/**/*']

  gem.add_dependency 'doorkeeper', '>= 5.0', '< 6.0'

  gem.add_development_dependency 'grape'
  gem.add_development_dependency 'coveralls'
  gem.add_development_dependency 'sqlite3', '~> 1.3.5'
  gem.add_development_dependency 'rspec-rails', '~> 3.7'
  gem.add_development_dependency 'capybara', '~> 2.17'
  gem.add_development_dependency 'generator_spec', '~> 0.9.4'
  gem.add_development_dependency 'factory_bot', '~> 4.8'
  gem.add_development_dependency 'database_cleaner', '~> 1.6.0'
end
