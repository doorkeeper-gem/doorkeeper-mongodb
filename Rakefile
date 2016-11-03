require 'bundler/setup'
require 'bundler/gem_helper'
require 'rspec/core/rake_task'

task :load_doorkeeper do
  `rm -rf spec/`
  `git checkout spec`
  `git submodule init`
  `git submodule update`
  `cd doorkeeper && git checkout v#{ENV['doorkeeper'] ||= '3.0.0'}`
  `cp -r -n doorkeeper/spec .`
  `bundle exec rspec`
end

desc 'Default: run specs.'
task default: :spec

desc 'Clone down doorkeeper specs'
task spec: :load_doorkeeper

RSpec::Core::RakeTask.new(:spec) do |config|
  config.verbose = false
end

Bundler::GemHelper.install_tasks
