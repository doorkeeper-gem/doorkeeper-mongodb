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
            where(token: token.to_s).find_first
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
