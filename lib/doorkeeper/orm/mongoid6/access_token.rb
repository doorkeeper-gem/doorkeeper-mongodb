module Doorkeeper
  class AccessToken
    include Mongoid::Document
    include Mongoid::Timestamps

    include DoorkeeperMongodb::Compatible

    include DoorkeeperMongodb::Shared::Scopes
    include DoorkeeperMongodb::Mixins::Mongoid::AccessTokenMixin

    store_in collection: :oauth_access_tokens

    field :resource_owner_id, type: BSON::ObjectId
    field :token, type: String
    field :refresh_token, type: String
    field :previous_refresh_token, type: String
    field :expires_in, type: Integer
    field :revoked_at, type: DateTime

    index({ token: 1 }, unique: true)
    index({ refresh_token: 1 }, unique: true, sparse: true)

    def self.order_method
      :order_by
    end

    def self.refresh_token_revoked_on_use?
      fields.collect { |field| field[0] }.include?('previous_refresh_token')
    end

    def self.created_at_desc
      %i[created_at desc]
    end
  end
end
