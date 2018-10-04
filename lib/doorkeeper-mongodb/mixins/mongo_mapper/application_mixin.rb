module DoorkeeperMongodb
  module Mixins
    module MongoMapper
      module ApplicationMixin
        extend ActiveSupport::Concern

        include Doorkeeper::OAuth::Helpers
        include Doorkeeper::Models::Scopes
        include BaseMixin

        included do
          many :access_grants, dependent: :destroy, class_name: 'Doorkeeper::AccessGrant'
          many :access_tokens, dependent: :destroy, class_name: 'Doorkeeper::AccessToken'

          validates :name, :secret, :uid, presence: true
          validates :uid, uniqueness: true
          validates :redirect_uri, redirect_uri: true
          validates :confidential, inclusion: { in: [true, false] }

          validate :scopes_match_configured, if: :enforce_scopes?

          before_validation :generate_uid, :generate_secret, on: :create
        end

        module ClassMethods
          # Returns an instance of the Doorkeeper::Application with
          # specific UID and secret.
          #
          # Public/Non-confidential applications will only find by uid if secret is
          # blank.
          #
          # @param uid [#to_s] UID (any object that responds to `#to_s`)
          # @param secret [#to_s] secret (any object that responds to `#to_s`)
          #
          # @return [Doorkeeper::Application, nil] Application instance or nil
          #   if there is no record with such credentials
          #
          def by_uid_and_secret(uid, secret)
            app = by_uid(uid)
            return unless app
            return app if secret.blank? && !app.confidential?
            return unless app.secret == secret
            app
          end

          # Returns an instance of the Doorkeeper::Application with specific UID.
          #
          # @param uid [#to_s] UID (any object that responds to `#to_s`)
          #
          # @return [Doorkeeper::Application, nil] Application instance or nil
          #   if there is no record with such UID
          #
          def by_uid(uid)
            where(uid: uid.to_s).first
          end

          # Revokes AccessToken and AccessGrant records that have not been revoked and
          # associated with the specific Application and Resource Owner.
          #
          # @param resource_owner [ActiveRecord::Base]
          #   instance of the Resource Owner model
          #
          def revoke_tokens_and_grants_for(id, resource_owner)
            Doorkeeper::AccessToken.revoke_all_for(id, resource_owner)
            Doorkeeper::AccessGrant.revoke_all_for(id, resource_owner)
          end
        end

        # Set an application's valid redirect URIs.
        #
        # @param uris [String, Array] Newline-separated string or array the URI(s)
        #
        # @return [String] The redirect URI(s) seperated by newlines.
        def redirect_uri=(uris)
          super(uris.is_a?(Array) ? uris.join("\n") : uris)
        end

        private

        def generate_uid
          if uid.blank?
            self.uid = UniqueToken.generate
          end
        end

        def generate_secret
          if secret.blank?
            self.secret = UniqueToken.generate
          end
        end

        def scopes_match_configured
          if scopes.present? &&
              !ScopeChecker.valid?(scopes.to_s, Doorkeeper.configuration.scopes)
            errors.add(:scopes, :not_match_configured)
          end
        end

        def enforce_scopes?
          Doorkeeper.configuration.enforce_configured_scopes?
        end
      end
    end
  end
end
