# frozen_string_literal: true

ENV["RAILS"] ||= "5.0"
ENV["DOORKEEPER"] ||= "5.0"

source "https://rubygems.org"

gemspec path: "../"

gem "rails", "~> #{ENV['RAILS']}"
gem "doorkeeper", "~> #{ENV['DOORKEEPER']}"
gem "bcrypt"

# Older Grape requires Ruby >= 2.2.2
if ENV["RAILS"][0] == "4"
  gem "grape", "~> 0.16", "< 0.19.2"
end
