module Doorkeeper
  class AccessGrant
    include DoorkeeperMongodb::Compatible

    include MongoMapper::Document

    include DoorkeeperMongodb::Mixins::MongoMapper::AccessGrantMixin

    safe
    timestamps!

    set_collection_name 'oauth_access_grants'

    key :resource_owner_id,     ObjectId
    key :application_id,        ObjectId
    key :token,                 String
    key :scopes,                String
    key :expires_in,            Integer
    key :redirect_uri,          String
    key :revoked_at,            Time
    key :code_challenge,        String
    key :code_challenge_method, String

    def self.create_indexes
      ensure_index :token, unique: true
    end

    def save!(options = {})
      if options.key?(:validate)
        super(options.merge(safe: options.delete(:validate)))
      else
        super
      end
    end
  end
end
