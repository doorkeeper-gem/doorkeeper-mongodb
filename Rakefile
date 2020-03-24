# frozen_string_literal: true

require "bundler/setup"
require "rspec/core/rake_task"

task :load_doorkeeper do
  `rm -rf spec/`
  `git checkout spec`
  unless Dir.exist?("doorkeeper")
    `git submodule init`
    `git submodule update`
  end
  `cp -r -n doorkeeper/spec .`
  `rm -rf spec/generators/` # we are not ActiveRecord
  `rm -rf spec/validators/`
  `bundle exec rspec`
end

desc "Update Git submodules."
task :update_submodules do
  Rake::Task["load_doorkeeper"].invoke if Dir["doorkeeper/*"].empty?

  `git submodule foreach git pull origin master`
end

desc "Default: run specs."
task default: :spec

desc "Clone down doorkeeper specs"
task spec: :load_doorkeeper

RSpec::Core::RakeTask.new(:spec) do |config|
  config.verbose = false
end

Bundler::GemHelper.install_tasks
