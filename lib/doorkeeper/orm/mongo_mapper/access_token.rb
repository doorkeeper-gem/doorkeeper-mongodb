require 'doorkeeper-mongodb/compatible'

module Doorkeeper
  class AccessToken
    include DoorkeeperMongodb::Compatible

    include MongoMapper::Document

    include DoorkeeperMongodb::Mixins::MongoMapper::AccessTokenMixin

    safe
    timestamps!

    set_collection_name 'oauth_access_tokens'

    key :resource_owner_id,       ObjectId
    key :application_id,          ObjectId
    key :token,                   String
    key :refresh_token,           String
    key :previous_refresh_token,  String
    key :expires_in,              Integer
    key :revoked_at,              DateTime
    key :scopes,                  String

    def self.last
      sort(:created_at).last
    end

    def self.delete_all_for(application_id, resource_owner)
      delete_all(application_id: application_id,
                 resource_owner_id: resource_owner.id)
    end
    private_class_method :delete_all_for

    def self.create_indexes
      ensure_index :token, unique: true
      ensure_index [[:refresh_token, 1]], unique: true, sparse: true
    end

    def self.refresh_token_revoked_on_use?
      keys.keys.include?('previous_refresh_token')
    end

    def self.order_method
      :sort
    end

    def self.created_at_desc
      :created_at.desc
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
