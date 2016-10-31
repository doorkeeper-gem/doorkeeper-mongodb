require 'doorkeeper/orm/mongoid5/concerns/scopes'
require 'doorkeeper/orm/access_grant_mixin_error_handler'
require 'doorkeeper-mongodb/compatible'

module Doorkeeper
  class AccessGrant
    include DoorkeeperMongodb::Compatible

    include Mongoid::Document
    include Mongoid::Timestamps

    include AccessGrantMixin
    include Models::Mongoid5::Scopes

    self.store_in collection: :oauth_access_grants

    field :resource_owner_id, type: BSON::ObjectId
    field :token, type: String
    field :expires_in, type: Integer
    field :redirect_uri, type: String
    field :revoked_at, type: DateTime

    index({ token: 1 }, { unique: true })
  end

  AccessGrant.send :prepend, Orm::AccessGrantMixinErrorHandler
end
