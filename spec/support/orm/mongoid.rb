# frozen_string_literal: true

DatabaseCleaner[:mongoid].strategy = :truncation
DatabaseCleaner[:mongoid].clean_with :truncation

# Monkey-patch for origin Doorkeeper specs that
# has `resource_owner.id + 1` :(
class BSON::ObjectId
  def +(_other)
    BSON::ObjectId.new
  end
end

RSpec.configure do |config|
  config.before do
    Doorkeeper::Application.create_indexes
    Doorkeeper::AccessGrant.create_indexes
    Doorkeeper::AccessToken.create_indexes
  end
end
