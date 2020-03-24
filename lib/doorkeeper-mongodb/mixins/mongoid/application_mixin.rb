# frozen_string_literal: true

module DoorkeeperMongodb
  module Mixins
    module Mongoid
      module ApplicationMixin
        extend ActiveSupport::Concern

        include Doorkeeper::OAuth::Helpers
        include Doorkeeper::Models::Scopes
        include Doorkeeper::Models::SecretStorable
        include BaseMixin

        included do
          has_many_options = {
            dependent: :delete
          }

          # Mongoid7 dropped :delete option
          if ::Mongoid::VERSION[0].to_i >= 7
            has_many_options[:dependent] = :delete_all
          end

          has_many :access_grants, has_many_options.merge(class_name: "Doorkeeper::AccessGrant")
          has_many :access_tokens, has_many_options.merge(class_name: "Doorkeeper::AccessToken")

          validates :name, :secret, :uid, presence: true
          validates :uid, uniqueness: true
          validates :redirect_uri, "doorkeeper/redirect_uri": true
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
            return unless app.secret_matches?(secret)
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

          def secret_strategy
            ::Doorkeeper.configuration.application_secret_strategy
          end

          def fallback_secret_strategy
            ::Doorkeeper.configuration.application_secret_fallback_strategy
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

        def secret_matches?(input)
          # return false if either is nil, since secure_compare depends on strings
          # but Application secrets MAY be nil depending on confidentiality.
          return false if input.nil? || secret.nil?

          # When matching the secret by comparer function, all is well.
          return true if secret_strategy.secret_matches?(input, secret)

          # When fallback lookup is enabled, ensure applications
          # with plain secrets can still be found
          if fallback_secret_strategy
            fallback_secret_strategy.secret_matches?(input, secret)
          else
            false
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

        def renew_secret
          @raw_secret = Doorkeeper::OAuth::Helpers::UniqueToken.generate
          secret_strategy.store_secret(self, :secret, @raw_secret)
        end

        def plaintext_secret
          if secret_strategy.allows_restoring_secrets?
            secret_strategy.restore_secret(self, :secret)
          else
            @raw_secret
          end
        end

        def as_json(options = {})
          hash = super

          if hash.key?("_id") || (options && Array.wrap(options[:only]).include?(:id))
            hash["id"] = id.to_s
          end
          hash["secret"] = plaintext_secret if hash.key?("secret")
          hash
        end

        def authorized_for_resource_owner?(resource_owner)
          Doorkeeper.configuration.authorize_resource_owner_for_client.call(self, resource_owner)
        end

        private

        def generate_uid
          if uid.blank?
            self.uid = UniqueToken.generate
          end
        end

        def generate_secret
          return unless secret.blank?

          @raw_secret = UniqueToken.generate
          secret_strategy.store_secret(self, :secret, @raw_secret)
        end

        def scopes_match_configured
          if scopes.present? &&
              !ScopeChecker.valid?(scope_str: scopes.to_s, server_scopes: Doorkeeper.configuration.scopes)
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
