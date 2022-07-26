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
            dependent: :delete,

          }

          # Mongoid7 dropped :delete option
          has_many_options[:dependent] = :delete_all if ::Mongoid::VERSION[0].to_i >= 7

          # Doorkeeper 5.3 has custom classes for defining OAuth roles
          access_grants_class_name = if DoorkeeperMongodb.doorkeeper_version?(5, 3)
                                       Doorkeeper.config.access_grant_class
                                     else
                                       "Doorkeeper::AccessGrant"
                                     end

          access_tokens_class_name = if DoorkeeperMongodb.doorkeeper_version?(5, 3)
                                       Doorkeeper.config.access_token_class
                                     else
                                       "Doorkeeper::AccessToken"
                                     end

          has_many :access_grants, has_many_options.merge(class_name: access_grants_class_name)
          has_many :access_tokens, has_many_options.merge(class_name: access_tokens_class_name)

          validates_presence_of :name, :secret, :uid
          validates_uniqueness_of :uid

          # Before Doorkeeper 5.2.3
          if defined?(::RedirectUriValidator)
            validates :redirect_uri, redirect_uri: true
          else
            validates :redirect_uri, "doorkeeper/redirect_uri": true
          end

          validates_inclusion_of :confidential, in: [true, false]

          validate :scopes_match_configured, if: :enforce_scopes?

          before_validation :generate_uid, :generate_secret, on: :create

          # Represents client as set of it's attributes in JSON format.
          # This is the right way how we want to override ActiveRecord #to_json.
          #
          # Respects privacy settings and serializes minimum set of attributes
          # for public/private clients and full set for authorized owners.
          #
          # @return [Hash] entity attributes for JSON
          #
          def as_json(options = {})
            # if application belongs to some owner we need to check if it's the same as
            # the one passed in the options or check if we render the client as an owner
            if (respond_to?(:owner) && owner && owner == options[:current_resource_owner]) ||
               options[:as_owner]
              # Owners can see all the client attributes, fallback to ActiveModel serialization
              super
            else
              # if application has no owner or it's owner doesn't match one from the options
              # we render only minimum set of attributes that could be exposed to a public
              only = extract_serializable_attributes(options)
              super(options.merge(only: only))
            end
          end

          def serializable_hash(options = nil)
            hash = super
            if hash.key?("_id")
              hash["id"] = hash.delete("_id")
            elsif options && Array.wrap(options[:only].map(&:to_sym)).include?(:id)
              hash["id"] = id.to_s
            end
            hash
          end

          # Helper method to extract collection of serializable attribute names
          # considering serialization options (like `only`, `except` and so on).
          #
          # @param options [Hash] serialization options
          #
          # @return [Array<String>]
          #   collection of attributes to be serialized using #as_json
          #
          def extract_serializable_attributes(options = {})
            opts = options.try(:dup) || {}
            only = Array.wrap(opts[:only]).map(&:to_s)

            only = if only.blank?
                     serializable_attributes
                   else
                     only & serializable_attributes
                   end

            only -= Array.wrap(opts[:except]).map(&:to_s) if opts.key?(:except)
            only.uniq
          end

          # We need to hook into this method to allow serializing plan-text secrets
          # when secrets hashing enabled.
          #
          # @param key [String] attribute name
          #
          def read_attribute_for_serialization(key)
            return super unless key.to_s == "secret"

            plaintext_secret || secret
          end

          # Collection of attributes that could be serialized for public.
          # Override this method if you need additional attributes to be serialized.
          #
          # @return [Array<String>] collection of serializable attributes
          def serializable_attributes
            attributes = %w[id name created_at]
            attributes << "uid" unless confidential?
            attributes
          end
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
          self.uid = UniqueToken.generate if uid.blank?
        end

        def generate_secret
          return if secret.present?

          @raw_secret = UniqueToken.generate
          secret_strategy.store_secret(self, :secret, @raw_secret)
        end

        def scopes_match_configured
          if scopes.present? &&
             !ScopeChecker.valid?(scope_str: scopes.to_s,
                                  server_scopes: Doorkeeper.configuration.scopes,)
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
