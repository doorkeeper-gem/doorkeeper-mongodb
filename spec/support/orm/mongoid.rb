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

  # Upstream examples that exercise ActiveRecord read/write database roles
  # (`ActiveRecord::Base.connected_to`). They are not tagged `active_record: true`
  # yet, so match them by description until upstream tags them.
  config.before do |example|
    if example.full_description.include?("with read replica support")
      skip "ActiveRecord-only example (database roles are not a Mongoid concept)"
    end
  end

  # Upstream StaleRecordsCleaner examples that stub `adapter_name` and expect
  # the ActiveRecord-specific "expiration time math" warning. The Mongoid
  # cleaner evaluates `created_at + expires_in` with `$expr`, so there is no
  # unsupported-adapter path to warn about.
  config.before do |example|
    if example.full_description.include?("when the model uses an unsupported database adapter")
      skip "ActiveRecord-only example (no database adapter fallback in the Mongoid cleaner)"
    end
  end

  config.before do
    Doorkeeper::Application.create_indexes
    Doorkeeper::AccessGrant.create_indexes
    Doorkeeper::AccessToken.create_indexes

    # To support custom attributes
    Doorkeeper::AccessToken.include WithCustomAttributes
    Doorkeeper::AccessGrant.include WithCustomAttributes
  end
end
