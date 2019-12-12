# frozen_string_literal: true

module Doorkeeper
  class Application
    include Mongoid::Document
    include Mongoid::Timestamps

    include DoorkeeperMongodb::Compatible

    # include DoorkeeperMongodb::Shared::Scopes
    include DoorkeeperMongodb::Mixins::Mongoid::ApplicationMixin

    include OAuth::Helpers
    include Models::Orderable
    include Models::SecretStorable
    include Models::Scopes

    store_in collection: :oauth_applications

    field :name, type: String
    field :uid, type: String
    field :secret, type: String
    field :redirect_uri, type: String
    field :confidential, type: Boolean, default: true

    index({ uid: 1 }, unique: true)

    has_many :authorized_tokens, class_name: 'Doorkeeper::AccessToken'

    # def self.authorized_for(resource_owner)
    #   ids = AccessToken.where(
    #     # resource_owner_id: resource_owner.id,
    #     # revoked_at: nil
    #   ).map(&:application_id)

    #   find(ids)
    # end

    # Returns Applications associated with active (not revoked) Access Tokens
    # that are owned by the specific Resource Owner.
    #
    # @param resource_owner [ActiveRecord::Base]
    #   Resource Owner model instance
    #
    # @return [ActiveRecord::Relation]
    #   Applications authorized for the Resource Owner
    #
    def self.authorized_for(resource_owner)
      resource_access_tokens = AccessToken.active_for(resource_owner)
      where(id: resource_access_tokens.select(:application_id).distinct)
    end

    # Revokes AccessToken and AccessGrant records that have not been revoked and
    # associated with the specific Application and Resource Owner.
    #
    # @param resource_owner [ActiveRecord::Base]
    #   instance of the Resource Owner model
    #
    def self.revoke_tokens_and_grants_for(id, resource_owner)
      AccessToken.revoke_all_for(id, resource_owner)
      AccessGrant.revoke_all_for(id, resource_owner)
    end

    # Generates a new secret for this application, intended to be used
    # for rotating the secret or in case of compromise.
    #
    def renew_secret
      @raw_secret = UniqueToken.generate
      secret_strategy.store_secret(self, :secret, @raw_secret)
    end

    # We keep a volatile copy of the raw secret for initial communication
    # The stored refresh_token may be mapped and not available in cleartext.
    #
    # Some strategies allow restoring stored secrets (e.g. symmetric encryption)
    # while hashing strategies do not, so you cannot rely on this value
    # returning a present value for persisted tokens.
    def plaintext_secret
      if secret_strategy.allows_restoring_secrets?
        secret_strategy.restore_secret(self, :secret)
      else
        @raw_secret
      end
    end

    def to_json(options = nil)
      serializable_hash(except: :secret)
        .merge(secret: plaintext_secret)
        .to_json(options)
    end

    private

    def generate_uid
      self.uid = UniqueToken.generate if uid.blank?
    end

    def generate_secret
      return unless secret.blank?
      renew_secret
    end

    def scopes_match_configured
      if scopes.present? &&
         !ScopeChecker.valid?(scope_str: scopes.to_s,
                              server_scopes: Doorkeeper.configuration.scopes)
        errors.add(:scopes, :not_match_configured)
      end
    end

    def enforce_scopes?
      Doorkeeper.configuration.enforce_configured_scopes?
    end
  end
end
