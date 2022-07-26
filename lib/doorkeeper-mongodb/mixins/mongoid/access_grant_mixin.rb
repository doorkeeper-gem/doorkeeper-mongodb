# frozen_string_literal: true

module DoorkeeperMongodb
  module Mixins
    module Mongoid
      module AccessGrantMixin
        extend ActiveSupport::Concern

        include Doorkeeper::OAuth::Helpers
        include Doorkeeper::Models::Expirable
        include Doorkeeper::Models::Revocable
        include Doorkeeper::Models::Accessible
        include Doorkeeper::Models::Scopes
        include Doorkeeper::Models::SecretStorable
        include Doorkeeper::Orm::Concerns::Mongoid::ResourceOwnerable
        include BaseMixin
        include JsonSerializable

        included do
          belongs_to_opts = {
            class_name: "Doorkeeper::Application",
            inverse_of: :access_grants,
          }

          # Doorkeeper 5.3 has custom classes for defining OAuth roles
          if DoorkeeperMongodb.doorkeeper_version?(5, 3)
            belongs_to_opts[:class_name] = Doorkeeper.config.application_class
          end

          # optional associations added in Mongoid 6
          belongs_to_opts[:optional] = true if ::Mongoid::VERSION[0].to_i >= 6

          belongs_to :application, belongs_to_opts

          if Doorkeeper.configuration.try(:polymorphic_resource_owner?)
            belongs_to :resource_owner, polymorphic: true
          end

          validates_presence_of :resource_owner_id, :application_id, :token,
                                :expires_in, :redirect_uri
          validates_uniqueness_of :token

          before_validation :generate_token, on: :create
        end

        # never uses pkce, if pkce migrations were not generated
        def uses_pkce?
          pkce_supported? && code_challenge.present?
        end

        def pkce_supported?
          respond_to? :code_challenge
        end

        def plaintext_token
          if secret_strategy.allows_restoring_secrets?
            secret_strategy.restore_secret(self, :token)
          else
            @raw_token
          end
        end

        module ClassMethods
          # Searches for Doorkeeper::AccessGrant record with the
          # specific token value.
          #
          # @param token [#to_s] token value (any object that responds to `#to_s`)
          #
          # @return [Doorkeeper::AccessGrant, nil] AccessGrant object or nil
          #   if there is no record with such token
          #
          def by_token(token)
            find_by_plaintext_token(:token, token)
          end

          # Revokes AccessGrant records that have not been revoked and associated
          # with the specific Application and Resource Owner.
          #
          # @param application_id [Integer]
          #   ID of the Application
          # @param resource_owner [Mongoid::Document, Integer]
          #   instance of the Resource Owner model
          #
          def revoke_all_for(application_id, resource_owner, clock = Time)
            by_resource_owner(resource_owner)
              .where(application_id: application_id, revoked_at: nil)
              .update_all(revoked_at: clock.now.utc)
          end

          # Implements PKCE code_challenge encoding without base64 padding as described in the spec.
          # https://tools.ietf.org/html/rfc7636#appendix-A
          #   Appendix A.  Notes on Implementing Base64url Encoding without Padding
          #
          #   This appendix describes how to implement a base64url-encoding
          #   function without padding, based upon the standard base64-encoding
          #   function that uses padding.
          #
          #       To be concrete, example C# code implementing these functions is shown
          #   below.  Similar code could be used in other languages.
          #
          #   static string base64urlencode(byte [] arg)
          #   {
          #       string s = Convert.ToBase64String(arg); // Regular base64 encoder
          #       s = s.Split('=')[0]; // Remove any trailing '='s
          #       s = s.Replace('+', '-'); // 62nd char of encoding
          #       s = s.Replace('/', '_'); // 63rd char of encoding
          #       return s;
          #   }
          #
          #   An example correspondence between unencoded and encoded values
          #   follows.  The octet sequence below encodes into the string below,
          #   which when decoded, reproduces the octet sequence.
          #
          #   3 236 255 224 193
          #
          #   A-z_4ME
          #
          # https://ruby-doc.org/stdlib-2.1.3/libdoc/base64/rdoc/Base64.html#method-i-urlsafe_encode64
          #
          # urlsafe_encode64(bin)
          # Returns the Base64-encoded version of bin. This method complies with
          # "Base 64 Encoding with URL and Filename Safe Alphabet" in RFC 4648.
          # The alphabet uses '-' instead of '+' and '_' instead of '/'.

          # @param code_verifier [#to_s] a one time use value (any object that responds to `#to_s`)
          #
          # @return [#to_s] An encoded code challenge based on the provided verifier suitable
          #   for PKCE validation
          def generate_code_challenge(code_verifier)
            padded_result = Base64.urlsafe_encode64(Digest::SHA256.digest(code_verifier))
            padded_result.split("=")[0] # Remove any trailing '='
          end

          delegate :pkce_supported?, to: :new

          ##
          # Determines the secret storing transformer
          # Unless configured otherwise, uses the plain secret strategy
          def secret_strategy
            ::Doorkeeper.config.token_secret_strategy
          end

          ##
          # Determine the fallback storing strategy
          # Unless configured, there will be no fallback
          def fallback_secret_strategy
            ::Doorkeeper.config.token_secret_fallback_strategy
          end
        end

        private

        # Generates token value with UniqueToken class.
        #
        # @return [String] token value
        #
        def generate_token
          return if self[:token].present?

          @raw_token = UniqueToken.generate
          secret_strategy.store_secret(self, :token, @raw_token)
        end
      end
    end
  end
end
