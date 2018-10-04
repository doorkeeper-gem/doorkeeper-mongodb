module Doorkeeper
  class Application
    include DoorkeeperMongodb::Compatible

    include MongoMapper::Document

    include DoorkeeperMongodb::Mixins::MongoMapper::ApplicationMixin

    safe
    timestamps!

    set_collection_name 'oauth_applications'

    many :authorized_tokens, class_name: 'Doorkeeper::AccessToken', dependent: :destroy

    key :name,         String
    key :uid,          String
    key :secret,       String
    key :redirect_uri, String
    key :confidential, Boolean
    key :scopes,       String

    def self.authorized_for(resource_owner)
      ids = AccessToken.where(
        resource_owner_id: resource_owner.id,
        revoked_at: nil
      ).map(&:application_id)

      find(ids)
    end

    def self.create_indexes
      ensure_index :uid, unique: true
    end

    def save!(options = {})
      if options.key?(:validate)
        super(options.merge(safe: options.delete(:validate)))
      else
        super
      end
    end
  end
end
