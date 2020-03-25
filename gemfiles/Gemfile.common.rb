# frozen_string_literal: true

ENV["RAILS"] ||= "5.0"
ENV["DOORKEEPER"] ||= "5.0"

source "https://rubygems.org"

gemspec path: "../"

gem "rails", "~> #{ENV["RAILS"]}"
gem "doorkeeper", "~> #{ENV["DOORKEEPER"]}"
gem "bcrypt"

gem "rspec-core"
gem "rspec-expectations"
gem "rspec-mocks"
gem "rspec-rails", "~> 4.0.0"
gem "rspec-support"
