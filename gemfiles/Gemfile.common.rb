# frozen_string_literal: true

ENV["RAILS"] ||= "5.0"
ENV["DOORKEEPER"] ||= "5.0"

source "https://rubygems.org"

gemspec path: "../"

gem "rails", "~> #{ENV['RAILS']}"
gem "doorkeeper", "~> #{ENV['DOORKEEPER']}"
gem "bcrypt"

gem "rspec-core", git: "https://github.com/rspec/rspec-core.git"
gem "rspec-expectations", git: "https://github.com/rspec/rspec-expectations.git"
gem "rspec-mocks", git: "https://github.com/rspec/rspec-mocks.git"
gem "rspec-rails", "4.0.0.rc1"
gem "rspec-support", git: "https://github.com/rspec/rspec-support.git"

# Older Grape requires Ruby >= 2.2.2
if ENV["RAILS"][0] == "4"
  gem "grape", "~> 0.16", "< 0.19.2"
end
