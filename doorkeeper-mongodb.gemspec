$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "doorkeeper-mongodb/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "doorkeeper-mongodb"
  s.version     = DoorkeeperMongodb::VERSION
  s.authors     = ["jasl"]
  s.email       = ["jasl9187@hotmail.com"]
  s.homepage    = "http://github.com/doorkeeper-gem/doorkeeper-mongodb"
  s.summary     = "Doorkeeper mongoid 2, 3, 4 and mongo_mapper ORMs"
  s.description = "Doorkeeper mongoid 2, 3, 4 and mongo_mapper ORMs"
  s.license     = "MIT"

  s.files = Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "doorkeeper", "~> 2.2.0"

  s.add_development_dependency "sqlite3", "~> 1.3.5"
  s.add_development_dependency "rspec-rails", "~> 3.2.0"
  s.add_development_dependency "capybara", "~> 2.3.0"
  s.add_development_dependency "generator_spec", "~> 0.9.0"
  s.add_development_dependency "factory_girl", "~> 4.5.0"
  s.add_development_dependency "timecop", "~> 0.7.0"
  s.add_development_dependency "database_cleaner", "~> 1.3.0"
  s.add_development_dependency "rspec-activemodel-mocks", "~> 1.0.0"
  s.add_development_dependency "bcrypt-ruby", "~> 3.0.1"
  s.add_development_dependency "pry", "~> 0.10.0"
end
