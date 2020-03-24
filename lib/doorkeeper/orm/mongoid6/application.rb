# frozen_string_literal: true

module Doorkeeper
  class Application
    include Mongoid::Document
    include Mongoid::Timestamps

    include DoorkeeperMongodb::Compatible

    include DoorkeeperMongodb::Shared::Scopes
    include DoorkeeperMongodb::Mixins::Mongoid::ApplicationMixin

    store_in collection: :oauth_applications

    field :name, type: String
    field :uid, type: String
    field :secret, type: String
    field :redirect_uri, type: String
    field :confidential, type: Boolean, default: true

    index({ uid: 1 }, unique: true)

    has_many_opts = {
      class_name: "Doorkeeper::AccessToken",
    }

    if DoorkeeperMongodb.doorkeeper_version?(5, 3)
      has_many_opts[:class_name] = Doorkeeper.config.access_token_class
    end

    has_many :authorized_tokens, has_many_opts

    def self.authorized_for(resource_owner)
      ids = AccessToken.where(
        resource_owner_id: resource_owner.id,
        revoked_at: nil,
      ).map(&:application_id)

      find(ids)
    end
  end
end
