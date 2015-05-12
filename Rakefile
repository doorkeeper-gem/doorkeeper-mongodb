require 'bundler/setup'
require 'rspec/core/rake_task'

desc 'Default: run specs.'
task :default => :spec

task :load_doorkeeper do
  `git submodule init`
  `git submodule update`
  `cp -r -n doorkeeper/spec .`
  `bundle exec rspec`
end

RSpec::Core::RakeTask.new(:spec) do |config|
  config.verbose = false
end

Rake::Task["spec"].enhance [:load_doorkeeper]

namespace :doorkeeper do
  desc "Install doorkeeper in dummy app"
  task :install do
    cd 'spec/dummy'
    system 'bundle exec rails g doorkeeper:install --force'
  end
end

Bundler::GemHelper.install_tasks
