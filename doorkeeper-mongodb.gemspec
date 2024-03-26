# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "doorkeeper-mongodb/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|
  gem.name        = "doorkeeper-mongodb"
  gem.version     = DoorkeeperMongodb.gem_version
  gem.authors     = ["jasl", "Nikita Bulai"]
  gem.email       = ["bulaj.nikita@gmail.com"]
  gem.homepage    = "http://github.com/doorkeeper-gem/doorkeeper-mongodb"
  gem.summary     = "Doorkeeper Mongoid ORM extension"
  gem.description = "Doorkeeper Mongoid ORM  extension"
  gem.license     = "MIT"

  gem.files      = Dir["lib/**/*", "config/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  gem.test_files = Dir["spec/**/*"]

  gem.add_dependency "doorkeeper", ">= 5.2", "< 6.0"

  gem.add_development_dependency "capybara"
  gem.add_development_dependency "coveralls_reborn"
  gem.add_development_dependency "database_cleaner-mongoid"
  gem.add_development_dependency "factory_bot", "~> 6.0"
  gem.add_development_dependency "generator_spec", "~> 0.10.0"
  gem.add_development_dependency "grape"
  gem.add_development_dependency "rake", ">= 11.3.0"
  gem.add_development_dependency "rspec-rails"
  gem.add_development_dependency "timecop"
end
