# frozen_string_literal: true

require "database_cleaner/mongoid"

DatabaseCleaner[:mongoid].strategy = :deletion
DatabaseCleaner[:mongoid].clean_with :deletion

# Monkey-patch for origin Doorkeeper specs that
# has `resource_owner.id + 1` :(
class BSON::ObjectId
  def +(_other)
    BSON::ObjectId.new
  end
end

module WithCustomAttributes
  extend ActiveSupport::Concern

  included do
    field :tenant_name, type: String
  end
end

RSpec.configure do |config|
  config.filter_run_excluding active_record: true

  config.before do
    Doorkeeper::Application.create_indexes
    Doorkeeper::AccessGrant.create_indexes
    Doorkeeper::AccessToken.create_indexes

    # To support custom attributes
    Doorkeeper::AccessToken.include WithCustomAttributes
    Doorkeeper::AccessGrant.include WithCustomAttributes
  end
end
