# frozen_string_literal: true

source "https://rubygems.org"

gemspec path: "../"

gem "rails", "~> #{ENV.fetch("RAILS", "5.0")}"
gem "doorkeeper", "~> #{ENV.fetch("DOORKEEPER", "5.0")}"
gem "bcrypt"

gem "database_cleaner-mongoid"
gem "rspec-core"
gem "rspec-expectations"
gem "rspec-mocks"
gem "rspec-rails", "~> 6.0.0"
gem "rspec-support"
gem "sprockets-rails"
gem "timecop"
