require 'doorkeeper/orm/mongoid3/concerns/scopes'

module Doorkeeper
  class AccessGrant
    include Mongoid::Document
    include Mongoid::Timestamps

    include AccessGrantMixin
    include Models::Mongoid3::Scopes

    self.store_in collection: :oauth_access_grants

    field :resource_owner_id, type: Moped::BSON::ObjectId
    field :application_id, type: BSON::ObjectId
    field :token, type: String
    field :expires_in, type: Integer
    field :redirect_uri, type: String
    field :revoked_at, type: DateTime

    index({ token: 1 }, { unique: true })
  end
end
