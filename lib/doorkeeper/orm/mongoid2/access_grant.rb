require 'doorkeeper/orm/mongoid2/concerns/scopes'
require 'doorkeeper-mongodb/compatible'

module Doorkeeper
  class AccessGrant
    include DoorkeeperMongodb::Compatible

    include Mongoid::Document
    include Mongoid::Timestamps

    include AccessGrantMixin
    include Models::Mongoid2::Scopes

    self.store_in :oauth_access_grants

    field :resource_owner_id, type: Integer
    field :token, type: String
    field :expires_in, type: Integer
    field :redirect_uri, type: String
    field :revoked_at, type: DateTime

    index :token, unique: true
  end
end
