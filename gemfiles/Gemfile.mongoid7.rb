# frozen_string_literal: true
gemfile = File.expand_path("../Gemfile.common.rb", __FILE__)
instance_eval IO.read(gemfile), gemfile

gem "mongoid", "~> 7.0"
