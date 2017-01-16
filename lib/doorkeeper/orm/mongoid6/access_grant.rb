require 'doorkeeper/orm/mongoid6/concerns/scopes'
require 'doorkeeper-mongodb/compatible'

module Doorkeeper
  class AccessGrant
    include DoorkeeperMongodb::Compatible

    include Mongoid::Document
    include Mongoid::Timestamps

    include AccessGrantMixin
    include Models::Mongoid6::Scopes

    self.store_in collection: :oauth_access_grants

    field :resource_owner_id, type: BSON::ObjectId
    field :token, type: String
    field :expires_in, type: Integer
    field :redirect_uri, type: String
    field :revoked_at, type: DateTime

    index({ token: 1 }, { unique: true })
  end
end
