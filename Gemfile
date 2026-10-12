# frozen_string_literal: true

source "https://rubygems.org"

# The test suite runs against the `doorkeeper` git submodule, not against the
# installed doorkeeper gem: the Bundler path source behind `gemspec` also picks
# up `doorkeeper/doorkeeper.gemspec` and puts `doorkeeper/lib` first on the load
# path. Check out the Doorkeeper tag you want to test against in the submodule.

gemspec

gem "bcrypt", "~> 3.1", require: false
gem "database_cleaner-mongoid"
gem "mongoid"
gem "rake"
gem "rspec-core"
gem "rspec-expectations"
gem "rspec-mocks"
gem "rspec-rails"
gem "rspec-support"
gem "rubocop", "~> 1.29.1"
gem "rubocop-performance", require: false
gem "rubocop-rails", require: false
gem "rubocop-rake", require: false
gem "rubocop-rspec", require: false
gem "sprockets-rails"
gem "timecop"
