# frozen_string_literal: true
module Doorkeeper
  class AccessGrant
    include Mongoid::Document
    include Mongoid::Timestamps

    include DoorkeeperMongodb::Compatible

    include DoorkeeperMongodb::Shared::Scopes
    include DoorkeeperMongodb::Mixins::Mongoid::AccessGrantMixin

    store_in collection: :oauth_access_grants

    field :resource_owner_id, type: BSON::ObjectId
    field :resource_owner_type, type: String
    field :token, type: String
    field :expires_in, type: Integer
    field :redirect_uri, type: String
    field :revoked_at, type: DateTime
    field :code_challenge, type: String
    field :code_challenge_method, type: String

    index({ token: 1 }, unique: true)
  end
end
