# frozen_string_literal: true

require "bundler/setup"
require "rspec/core/rake_task"

class ExtensionIntegrator
  def self.gsub(filepath, pattern, value)
    file = File.read(filepath)
    updated_file = file.gsub(pattern, value)
    File.open(filepath, "w") { |line| line.puts(updated_file) }
  end
end

task :load_doorkeeper do
  `rm -rf spec/`
  `git checkout spec`
  if Dir["doorkeeper/*"].empty?
    puts `git submodule init`
    puts `git submodule update`
  end
  `cp -r -n doorkeeper/spec .`
  `rm -rf spec/generators/` # we are not ActiveRecord
  `rm -rf spec/validators/`
  ExtensionIntegrator.gsub(
    "spec/spec_helper.rb",
    'require "database_cleaner"',
    "",
  )
  `rm ./spec/models/doorkeeper/application_spec.rb`
  `bundle exec rspec`
end

desc "Update Git submodules."
task :update_submodules do
  Rake::Task["load_doorkeeper"].invoke if Dir["doorkeeper/*"].empty?

  `git submodule foreach git pull origin main`
end

desc "Default: run specs."
task default: :spec

desc "Clone down doorkeeper specs"
task spec: :load_doorkeeper

RSpec::Core::RakeTask.new(:spec) do |config|
  config.verbose = false
end

Bundler::GemHelper.install_tasks
