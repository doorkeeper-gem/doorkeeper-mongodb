require 'doorkeeper/orm/mongoid4/concerns/scopes'
require 'doorkeeper-mongodb/compatible'
require 'doorkeeper-mongodb/access_token_shared'

module Doorkeeper
  class AccessToken
    include DoorkeeperMongodb::Compatible

    include Mongoid::Document
    include Mongoid::Timestamps

    include AccessTokenMixin
    include DoorkeeperMongodb::AccessTokenShared
    include Models::Mongoid4::Scopes

    self.store_in collection: :oauth_access_tokens

    field :resource_owner_id, type: BSON::ObjectId
    field :token, type: String
    field :refresh_token, type: String
    field :expires_in, type: Integer
    field :revoked_at, type: DateTime

    index({ token: 1 }, { unique: true })
    index({ refresh_token: 1 }, { unique: true, sparse: true })
  end
end
