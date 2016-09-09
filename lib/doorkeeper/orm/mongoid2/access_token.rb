require 'doorkeeper/orm/mongoid2/concerns/scopes'
require 'doorkeeper-mongodb/compatible'
require 'doorkeeper-mongodb/access_token_shared'

module Doorkeeper
  class AccessToken
    include DoorkeeperMongodb::Compatible

    include Mongoid::Document
    include Mongoid::Timestamps

    include AccessTokenMixin
    include DoorkeeperMongodb::AccessTokenShared
    include Models::Mongoid2::Scopes

    self.store_in :oauth_access_tokens

    field :resource_owner_id, type: Integer
    field :token, type: String
    field :refresh_token, type: String
    field :expires_in, type: Integer
    field :revoked_at, type: DateTime

    index :token, unique: true
    index :refresh_token, unique: true, sparse: true
  end
end
