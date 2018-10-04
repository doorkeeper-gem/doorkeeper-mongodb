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
        include BaseMixin

        included do
          belongs_to_opts = {
            class_name: 'Doorkeeper::Application',
            inverse_of: :access_grants
          }

          # optional associations added in Mongoid 6
          if ::Mongoid::VERSION[0].to_i >= 6
            belongs_to_opts[:optional] = true
          end

          belongs_to :application, belongs_to_opts

          validates :resource_owner_id, :application_id, :token, :expires_in, :redirect_uri, presence: true
          validates :token, uniqueness: true

          before_validation :generate_token, on: :create
        end

        # never uses pkce, if pkce migrations were not generated
        def uses_pkce?
          pkce_supported? && code_challenge.present?
        end

        def pkce_supported?
          respond_to? :code_challenge
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
            where(token: token.to_s).first
          end

          # Revokes AccessGrant records that have not been revoked and associated
          # with the specific Application and Resource Owner.
          #
          # @param application_id [Integer]
          #   ID of the Application
          # @param resource_owner [ActiveRecord::Base]
          #   instance of the Resource Owner model
          #
          def revoke_all_for(application_id, resource_owner, clock = Time)
            where(application_id:    application_id,
                  resource_owner_id: resource_owner.id,
                  revoked_at:        nil)
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
          # @return [#to_s] An encoded code challenge based on the provided verifier suitable for PKCE validation
          def generate_code_challenge(code_verifier)
            padded_result = Base64.urlsafe_encode64(Digest::SHA256.digest(code_verifier))
            padded_result.split('=')[0] # Remove any trailing '='
          end

          def pkce_supported?
            new.pkce_supported?
          end
        end

        private

        # Generates token value with UniqueToken class.
        #
        # @return [String] token value
        #
        def generate_token
          self.token = UniqueToken.generate
        end
      end
    end
  end
end
