$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "doorkeeper_bundle/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "doorkeeper_bundle"
  s.version     = DoorkeeperBundle::VERSION
  s.authors     = ["jasl"]
  s.email       = ["jasl9187@hotmail.com"]
  s.homepage    = "http://github.com/jasl/doorkeeper_bundle"
  s.summary     = "Doorkeeper with extracted ORM specifics, including mongoid 2-4 and mongo_mapper."
  s.description = "Doorkeeper with extracted ORM specifics, including mongoid 2-4 and mongo_mapper"
  s.license     = "MIT"

  s.files = Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 3.1"

  s.add_development_dependency "rspec-rails", "~> 2.99.0"
  s.add_development_dependency "factory_girl", "~> 4.4.0"
  s.add_development_dependency "timecop", "~> 0.7.0"
  s.add_development_dependency "database_cleaner", "~> 1.3.0"
end
