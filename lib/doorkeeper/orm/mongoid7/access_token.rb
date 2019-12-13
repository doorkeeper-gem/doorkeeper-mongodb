# frozen_string_literal: true

module Doorkeeper
  class AccessToken
    include Mongoid::Document
    include Mongoid::Timestamps

    include DoorkeeperMongodb::Compatible

    # include DoorkeeperMongodb::Shared::Scopes
    include DoorkeeperMongodb::Mixins::Mongoid::AccessTokenMixin

    include Doorkeeper::OAuth::Helpers
    include Doorkeeper::Models::Expirable
    include Doorkeeper::Models::Revocable
    include Doorkeeper::Models::Accessible
    include Doorkeeper::Models::Orderable
    include Doorkeeper::Models::SecretStorable
    include Doorkeeper::Models::Scopes
    include Doorkeeper::Models::Reusable

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

    def self.created_at_desc
      %i[created_at desc]
    end

    # Searches for not revoked Access Tokens associated with the
    # specific Resource Owner.
    #
    # @param resource_owner [ActiveRecord::Base]
    #   Resource Owner model instance
    #
    # @return [ActiveRecord::Relation]
    #   active Access Tokens for Resource Owner
    #
    def self.active_for(resource_owner)
      where(resource_owner_id: resource_owner.id, revoked_at: nil)
    end

    def self.refresh_token_revoked_on_use?
      fields.include?("previous_refresh_token")
    end
  end
end
