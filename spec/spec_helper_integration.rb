ENV['RAILS_ENV'] ||= 'test'
DOORKEEPER_ORM = (ENV['orm'] || 'mongoid4').to_sym

$LOAD_PATH.unshift File.dirname(__FILE__)

require 'dummy/config/environment'
require 'rspec/rails'
require 'rspec/autorun'
require 'timecop'
require 'database_cleaner'

Rails.logger.info  "====> Doorkeeper.orm = #{Doorkeeper.configuration.orm.inspect}"
Rails.logger.info "====> Rails version: #{Rails.version}"
Rails.logger.info "====> Ruby version: #{RUBY_VERSION}"

orm_name = Doorkeeper.configuration.orm.to_s.include?('mongoid') ? :mongoid : Doorkeeper.configuration.orm
require "support/orm/#{orm_name}"

ENGINE_RAILS_ROOT = File.join(File.dirname(__FILE__), '../')

Dir["#{File.dirname(__FILE__)}/support/{dependencies,helpers,shared}/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.mock_with :rspec

  config.infer_base_class_for_anonymous_controllers = false

  config.before do
    DatabaseCleaner.start
    Doorkeeper.configure { orm DOORKEEPER_ORM }
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.order = 'random'
end
